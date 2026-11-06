#!/usr/bin/env bash
# PreToolUse guard (matchers: "Bash" and "mcp__.*").
#   prod data sources, git push, GitLab/GitHub comments -> deny (exit 2, reason goes to Claude)
#   other remote writes                                 -> ask (forces a prompt, even in auto mode)
# ponytail: regex on the command text, not a shell parser; `sh -c "git push"` slips through.

in=$(cat)
tool=$(jq -r '.tool_name // empty' <<<"$in")
blob=$(jq -c '.tool_input // {}' <<<"$in")

deny() { echo "guard.sh: $1" >&2; exit 2; }
ask() { jq -cn --arg r "guard.sh: $1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'; exit 0; }

# Set to the new job's prod tunnel ports and prod data-source names (IDE data-source UUIDs can be added to PROD_NAME).
PROD_PORT='(^|[^0-9])(5434|27019)([^0-9]|$)'
PROD_NAME='(pg|mongo)-prod|Prod (PG|Mongo)'
NO_PROD='production data. Write the query and hand it to the user to run.'
NO_COMMENT='comments and thread replies are posted by the user. Draft the text instead.'

case "$tool" in
  Bash)
    cmd=$(jq -r '.command // empty' <<<"$blob")
    if grep -Eq "$PROD_PORT" <<<"$cmd" && grep -Eiq 'psql|pg_dump|postgres|jdbc|mongo' <<<"$cmd"; then deny "$NO_PROD"; fi
    grep -Eq "$PROD_NAME" <<<"$cmd" && deny "$NO_PROD"
    grep -Eq '(^|[^[:alnum:]_-])bq[[:space:]].*production' <<<"$cmd" && deny "$NO_PROD"

    # One line per shell segment, leading keywords/assignments stripped, so `echo "... git push"` is not a push.
    segs=$(printf '%s\n' "$cmd" | perl -0pe 's/\\\n/ /g' | perl -pe 's/\|\||&&|[;|&]/\n/g' \
      | perl -pe 's/^\s*((then|do|else|!|\(|\{)\s+)*//; s/^(env\s+)?([A-Za-z_][A-Za-z0-9_]*=\S*\s+)*//')
    grep -Eq '^git([[:space:]]+(-[Cc][[:space:]]+[^[:space:]]+|--[a-z-]+(=[^[:space:]]+)?))*[[:space:]]+push([[:space:]]|$)' <<<"$segs" \
      && deny "git push is the user's job. Say the branch is ready to push."
    grep -Eq '^glab[[:space:]]+(mr|issue)[[:space:]]+note|^gh[[:space:]]+(pr|issue)[[:space:]]+comment' <<<"$segs" && deny "$NO_COMMENT"
    grep -Eq '^glab[[:space:]]+(mr[[:space:]]+(merge|approve|update|close|reopen|create)|issue[[:space:]]+(create|close|update))' <<<"$segs" \
      && ask "GitLab write"
    while IFS= read -r a; do
      [ -z "$a" ] && continue
      target=$a
      if grep -q 'graphql' <<<"$a"; then
        grep -q 'mutation' <<<"$cmd" || continue
        target=$cmd
      elif grep -Eq '(-X|--method)[[:space:]=]*GET' <<<"$a"; then continue
      # glab/gh api switch to POST when fields are passed without an explicit method
      elif ! grep -Eq '(-X|--method)[[:space:]=]*(POST|PUT|PATCH|DELETE)|[[:space:]](-f|-F|--field|--raw-field)[[:space:]]' <<<"$a"; then continue
      fi
      grep -Eiq '/notes|/discussions|createNote|createDiscussion' <<<"$target" && deny "$NO_COMMENT"
      ask "GitLab API write"
    done <<<"$(grep -E '^(glab|gh)[[:space:]]+api' <<<"$segs")"
    grep -Eq '^gh[[:space:]]+(pr|issue)[[:space:]]+(create|merge|close|edit|review)' <<<"$segs" && ask "GitHub write"
    grep -Eq '^(gcloud[[:space:]]+storage|gsutil)[[:space:]]+(rm|mv)([[:space:]]|$)|^(gcloud[[:space:]]+storage|gsutil)[[:space:]]+(cp|rsync)[[:space:]].*[[:space:]]gs://[^[:space:]]*[[:space:]]*$' <<<"$segs" \
      && ask "GCS write or delete"
    ;;
  mcp__idea__execute_terminal_command)
    deny "use the Bash tool; the IntelliJ terminal bypasses this guard." ;;
  mcp__idea__create_database_connection|mcp__idea__edit_database_connection|mcp__idea__execute_run_configuration)
    ask "IntelliJ connection/run-config change" ;;
  mcp__idea__*)
    grep -Eq "$PROD_NAME" <<<"$blob" && deny "$NO_PROD" ;;
  mcp__bigquery__*)
    grep -q 'production' <<<"$blob" && deny "$NO_PROD" ;;
  mcp__jira__jira_create*|mcp__jira__jira_update*|mcp__jira__jira_delete*|mcp__jira__jira_add*|mcp__jira__jira_edit*|mcp__jira__jira_transition*|mcp__jira__jira_assign*|mcp__jira__jira_link*|mcp__jira__jira_remove*|mcp__jira__jira_move*|mcp__jira__jira_batch_create*)
    ask "Jira write" ;;
  mcp__claude_ai_Atlassian__create*|mcp__claude_ai_Atlassian__edit*|mcp__claude_ai_Atlassian__add*|mcp__claude_ai_Atlassian__update*|mcp__claude_ai_Atlassian__transition*)
    ask "Atlassian write" ;;
  mcp__*slack__slack_send*|mcp__*slack__slack_schedule*|mcp__*slack__slack_create*|mcp__*slack__slack_update*|mcp__*slack__slack_add*)
    ask "Slack write" ;;
  mcp__sentry__update_issue)
    ask "Sentry write" ;;
esac
exit 0
