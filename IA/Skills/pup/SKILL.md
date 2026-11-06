---
name: pup
description: Use when querying or managing Datadog via CLI — searching logs, metrics, monitors, traces, incidents, SLOs, dashboards, or any Datadog API domain from the terminal or in scripts.
---

# pup — Datadog API CLI

Datadog CLI with OAuth2 + API key auth. 30+ API domains.

## Auth

```bash
pup auth login               # OAuth2 (preferred)
pup auth status              # check current session

# Or env vars:
export DD_API_KEY=...
export DD_APP_KEY=...
export DD_SITE=datadoghq.eu  # or datadoghq.com (default)
```

## Agent Mode (CRITICAL)

When running inside an AI coding assistant, pup auto-detects agent mode and wraps responses in:
```json
{ "status": "ok", "data": [...], "metadata": {...} }
```

**When writing scripts or commands for the user to run outside this session, always append `--no-agent`** — otherwise the envelope shape won't match what they see:
```bash
# Interactive (envelope-wrapped, fine for agent):
pup monitors list --tag='env:prod'

# Script for user/CI (raw output):
pup --no-agent monitors list --tag='env:prod' | jq '.[].name'
```

## Global Flags

| Flag | Description |
|------|-------------|
| `--output json\|table\|yaml\|csv` | Output format (default: json) |
| `--org NAME` | Multi-org named session |
| `--yes` | Skip confirmation prompts |
| `--no-agent` | Force raw output (use in scripts) |

## Key Commands

```bash
# Logs
pup logs search --query 'service:api status:error' --from 1h
pup logs aggregate --query 'service:api' --compute count --from 1h

# Metrics
pup metrics query 'avg:system.cpu.user{env:prod} by {host}' --from 1h --to now

# Monitors
pup monitors list --tag 'env:prod' --status alert
pup monitors get <id>

# Traces / APM
pup traces search --query 'service:checkout error:true' --from 30m
pup traces aggregate --query 'service:checkout' --compute p95:duration --by service

# Events
pup events search --query 'source:deployment' --from 24h

# Incidents
pup incidents list --status active

# Dashboards / SLOs
pup dashboards list
pup slos list --tags 'team:backend'

# Raw API (when no command exists)
pup api GET /api/v1/validate
```

## Anti-Patterns (from pup itself)

- **Always set `--from`** on time-series queries — omitting it gives unexpected ranges
- **Start with small `--limit`** — don't use 1000 as first step
- **APM durations are NANOSECONDS** — not ms or s
- **Use `logs aggregate` for counts** — don't fetch raw logs to count them
- **Check error before retrying** — 401 = re-authenticate, 403 = missing permissions
- **Always specify aggregation** on `metrics query` (avg, sum, max, min, count)

## Useful Subcommands

```bash
pup bits ask "why is error rate spiking on checkout service?"
pup docs ask "how do I set up log-based metrics?"
pup idp find <service>          # service context from Software Catalog
pup change-stories list <svc>   # deployments / config changes for a service
pup ddsql time-series "SELECT ..."  # DDSQL queries
```
