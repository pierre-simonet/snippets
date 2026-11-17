# Claude Code plugins

Plugins and mods worth turning on in Claude Code: how to enable them, use them, and turn them off.

## You should know

Built-in mod `cc-plugin-you-should-know@builtin`. Off by default. Requires Claude Code v2.1.287 or later.

While Claude works through a longer task, a side agent rereads the conversation from time to time and flags the one thing you might have missed, such as a tradeoff Claude chose without calling it out or a result that may be off. The note shows above the prompt input:

```text
✦ Heads up · There was a change to how folder sharing starts in June, which may have bumped usage metrics artificially.
  1: Learn more   2: Knew this already   0: Dismiss
```

The side agent is a separate request to the same model, with no tools: it can't read files, run commands, or change what Claude does.

### Enable

At the Claude Code prompt:

```text
/plugin enable cc-plugin-you-should-know@builtin
```

Or from the shell (applies to the next session):

```bash
claude plugin enable cc-plugin-you-should-know@builtin
```

`/plugin` lists it only when you connect to the Claude API directly, with a claude.ai account or a Console API key. It isn't available:

- behind an LLM gateway or a Claude apps gateway, or with a key from `apiKeyHelper`
- in a session that doesn't fetch feature flags, e.g. with `DISABLE_TELEMETRY` set
- in the first session after an install or upgrade, before the flags arrive

In those cases the enable command answers `Plugin "cc-plugin-you-should-know@builtin" is not installed in this project`.

Notes are drawn in the terminal, the Desktop app's Code tab and the VS Code extension (2.1.299+). Not in `claude -p`, the Agent SDK or cloud sessions.

### Answer a note

Type the digit alone into an empty prompt input:

| Key | Choice | Effect |
| :-- | :-- | :-- |
| `1` | Learn more | Opens a short explanation under the note |
| `2` | Knew this already | Closes the note and marks the topic as known, so it isn't raised again |
| `0` | Dismiss | Closes the note |

Under **Learn more**:

- **Understood**: closes it and marks the topic as known
- **Chat in main session**: quotes the note into the prompt input so you can add a question and send it to Claude
- **Dismiss**: closes it without marking the topic as known

The main agent never sees a note unless you send it with **Chat in main session**.

Recent notes and known topics are kept in `~/.claude/plugins/store/cc-plugin-you-should-know*` and reused by later sessions so they aren't repeated. To reset them, delete that file while no session is running.

### Cost

Each check is a background request to the session's model and counts toward plan usage limits or API costs. The conversation part is read from the prompt cache; the mod's instructions (several thousand tokens) and the side agent's reply are billed in full on every check.

To watch the checks happen:

```bash
CLAUDE_CODE_YOU_SHOULD_KNOW_DEBUG=1 claude
```

### Disable

```text
/plugin disable cc-plugin-you-should-know@builtin
```

Or from the **Installed** tab of `/plugin`, or choose **Dismiss** on a note (without opening **Learn more**), then **Turn off suggestions** on the `Dismissed.` line within 20 seconds.

`--safe-mode` and `"disableAllHooks": true` don't stop built-in mods.

Docs: [You should know suggestions](https://code.claude.com/docs/en/interactive-mode#you-should-know-suggestions) · [Mods built into Claude Code](https://code.claude.com/docs/en/plugins/mods/overview#mods-built-into-claude-code)
