#!/usr/bin/env bash
# Blocks Bash commands that reference .env files
CMD=$(jq -r '.tool_input.command // ""')
if echo "$CMD" | grep -qE '(^|[[:space:]]|/)\.env([[:space:]]|$|\.|_)'; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked: sensitive file (.env)"}}'
fi
