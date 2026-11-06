---
name: datadog-analyzer
description: Analyze one Datadog Error Tracking issue for the current repo — fetch it, explain the context in plain language, trace the call chain into the repo (repo-relative path + method + line), state the root cause, and propose 1-3 fix options when a code fix makes sense. Use when the user pastes a Datadog error-tracking / logs / APM link, gives a Datadog issue UUID, says "analyze this datadog issue", "datadog error tracking", "why is this erroring in datadog", or invokes "/datadog-analyzer". Read-only — never changes the issue state, never comments in Datadog, never edits code. For raw Datadog CLI queries see `pup`.
---

# Datadog Issue Analyzer

Turn a Datadog Error Tracking issue into a short, easy explanation: what breaks,
where in the code, why, and how to fix it.

## Scope boundary

- Fetch → context → call chain → root cause → fix options. That's it.
- **Read-only in Datadog.** Never call `update_datadog_error_tracking_issue`,
  `manage_datadog_error_tracking_issue_comments`, or any write `pup` command.
- **Read-only in the repo.** Propose fixes, don't apply them. Wait for an
  explicit OK before touching any file.

## Input

Free text. Parse intent:

- Extract a UUID with a regex
  (`[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}`) from
  whatever was pasted (error-tracking URL, `issueId=` query param, raw id).
  Don't rely on a specific Datadog URL layout.
- A log or trace link → analyze that event directly via 1c (logs and
  spans often carry no `issue.id`, so you can't hop from them to the issue).
- Free text (e.g. "NPE on orders-api yesterday") → search issues with
  `service:<x> error.type:<y>`, list the top 3, analyze the first, say which
  one you picked.
- Nothing → ask for the issue link or id. Stop.

## Step 1 — Fetch the issue (fallback chain)

Try sources in this order. Use the first that works and **name it in the
output** (`Source: MCP error-tracking | pup | logs/spans fallback`).

### 1a. Datadog MCP error-tracking tools (preferred)

Load the `datadog/error-tracking` skill once (`load_datadog_skill`), then:

- `get_datadog_error_tracking_issue` — stack trace, message, service, env,
  first/last seen, counts, `last_error` (has `trace_id` on backend errors).
- `analyze_datadog_error_tracking_errors` filtered on `issue.id:<uuid>` —
  breakdown by `version`, occurrences over time, sample `trace_id`s. Use only
  when the trend or version split matters (regression suspicion).

`get` takes no time range: its counts cover the 24h before last seen. Label
the Volume line that way, don't invent a window.

MCP tools are deferred, so check availability with `ToolSearch` query
`error_tracking`. No match → the `error-tracking` toolset is disabled. Tell
the user to enable it with `/ddtoolsets`, then **restart Claude Code**.
Meanwhile continue with 1b.

### 1b. pup CLI

Set `DD_SITE` to the org's Datadog site (`datadoghq.com`, `datadoghq.eu`, ...); pup defaults to `.com`.

```bash
DD_SITE=<site> pup error-tracking issues get <uuid>
```

Not authenticated → tell the user to run `! pup auth login --site <site>`,
and continue with 1c.

### 1c. Logs / spans fallback (always available via MCP)

Logs and spans often have **no `issue.id` attribute** (check: `issue.id:*`
on logs and `@issue.id:*` on spans). If both return 0, this path can't resolve
a bare UUID. It works only when you already know service + error type or
message: from free text, a pasted log/trace link, or the 1a/1b result.

Load the tools first with `ToolSearch` query
`select:mcp__plugin_datadog_mcp__search_datadog_logs,mcp__plugin_datadog_mcp__search_datadog_spans,mcp__plugin_datadog_mcp__get_datadog_trace`.

- `mcp__plugin_datadog_mcp__search_datadog_logs` —
  `service:<s> status:error "<message fragment>"`, `limit: 1-3`,
  `extra_fields: ["error*", "logger*", "command*"]`. Stack is in
  `custom.error.stack`; `git.commit.sha` and `version` are in `tags`.
- `mcp__plugin_datadog_mcp__search_datadog_spans` —
  `service:<s> status:error @error.type:<FQCN>`, `limit: 1`,
  `custom_attributes: ["error.*", "git.*"]`, `max_tokens: 10000` (Spring
  stacks on spans run ~8k tokens). `resourcename` gives the entry point.
- `mcp__plugin_datadog_mcp__get_datadog_trace` on one `trace_id` with
  `only_service_entry_spans: true` — upstream caller, cross-service path.
- Volume: `mcp__plugin_datadog_mcp__analyze_datadog_logs` count over the
  same query, if loaded. Say counts are approximate in this mode.

Only a UUID and 1a/1b both blocked → stop. Give the two unblock commands and
offer: "or paste the error type + service and I'll analyze from logs".

## Step 2 — Gather context

Collect, keep only what's useful:

- Service, env, error type + message, handled/unhandled.
- Occurrences, impacted users/sessions if RUM, first seen / last seen.
- `version` / `git.commit.sha` tag of the failing build.
- Entry point: HTTP route (`resource_name`, `@http.url`), message listener,
  or scheduled job — from the span/trace when available.
- Regression check: does first seen line up with a deploy? If the version
  tag resolves to a commit, find the likely introducing change:

```bash
git log --oneline -10 <sha> -- <files from the call chain>
```

## Step 3 — Build the call chain

Every frame you print must come from a file you actually opened. Never copy a
line number straight from the stack trace.

1. Keep only the org's own frames (`<your package prefixes>`, e.g. `com.acme.*`,
   and their log abbreviations like `c.a.*`; app/module code for frontend). Drop JDK,
   Spring, kotlin/kotlinx (`k.c.*`), `j.u.c.*`, Hibernate/JOOQ internals,
   `$$SpringCGLIB$$`/proxy frames, and duplicate `invoke`/`invokeSuspend`
   lambda frames.
2. Locate each file by the **file name in parentheses**, not the class name:
   `PlaceOrderCommand.execute(OrderUsecases.kt:387)` lives in
   `OrderUsecases.kt`. Run `git ls-files | grep '/<File>.kt$'`. Several
   matches → disambiguate with the package and service name.
   Frames in `*.generated.*` packages are OpenAPI build output, not in git:
   keep them as the entry-point label only.
3. Read the source **at the deployed version** (full SHA from the
   `git.commit.sha` tag, short SHA from `version`):
   - `git cat-file -t <sha>` fails → `git fetch origin <sha>`, retry.
   - Then `git show "${SHA}:${FILE}"`. Always brace the variable: in zsh,
     `$SHA:t…` / `$SHA:h…` are path modifiers and silently corrupt the arg.
   - No SHA tag, or the fetch fails too → read HEAD and mark the chain
     `lines from HEAD, may drift`.
4. Confirm the line holds the call the stack claims. If it drifted, find the
   call by method name and use the real line.
5. Order top-down: entry point (controller / listener / job, from the trace)
   → service calls → throw site.

Frontend / RUM stacks are often minified. Say so, and locate the code from
`view.url_path`, component names, and the error message instead.

## Step 4 — Root cause

Read the code around the throw site (callers, inputs, recent changes) and
state the root cause in plain language: which input or state triggers it and
why the code doesn't handle it. Separate fact from inference — if a link in
the reasoning is a guess (e.g. "probably a profile without a country"), say
so and say what would confirm it (a log query, a DB lookup).

Classify:

- **Code bug** → fix options.
- **Data issue** (bad row, missing reference) → data fix + optional guard.
- **Transient / infra** (timeout, connection reset, downstream 5xx) → no code
  fix unless retry/resilience is missing; give the operational action.

## Step 5 — Output

Use exactly this shape. Keep each section short. No stack dumps, no raw JSON.

```markdown
## <ErrorType>: <short message> — <service> (<env>)

**In short:** 3-5 plain-language sentences. What the user/system was doing,
what breaks, why, how bad. No class names here.

**Context**
- Source: MCP error-tracking | pup | logs/spans fallback
- Volume: <N> occurrences (<window>), <users/sessions if RUM>
- Seen: first <date> · last <date> · version <version>
- Entry: <HTTP route / listener / job>
- Regression: <yes, since <commit/MR> | no, long-standing | unknown>

**Call chain** (lines @ <sha> | lines from HEAD, may drift)
1. `path/to/EntryController.kt:42` — `EntryController.handle()`
2. `path/to/SomeService.kt:118` — `SomeService.load()`
3. `path/to/Resolver.kt:27` — `Resolver.resolve()` ← throws here

**Root cause**
1-3 sentences. Mark inferences as such.

**Fix options**
1. **<name> (recommended)** — what to change, where (`path:line`). Trade-off in one line.
2. **<name>** — … Trade-off in one line.
(No code fix: <why> — <operational action>.)
```

Rules for the output:

- Paths are repo-relative and in `path:line` form so they're clickable.
- 1-3 fix options, recommended first. Each says *why* it fixes the root cause,
  not just *what* to change.
- Fixes follow the repo's conventions (language, comment style, domain
  patterns). Don't propose swallowing the exception as the default.
- After the output, offer: "Want me to apply option N?" — then stop.

## Rules

- Read-only everywhere. No Datadog writes, no file edits, no commits.
- Every `path:line` in the output was verified by reading the file.
- Name the data source used and any degraded mode (HEAD lines, fallback counts,
  minified stack).
- Plain-language summary first, detail after.
