#!/usr/bin/env bash
# Blocks Read, Glob, and Grep tool calls targeting .env files
FILE=$(jq -r '.tool_input.file_path // .tool_input.path // .tool_input.pattern // ""')
BASENAME=$(basename "$FILE")
if [[ "$BASENAME" == .env || "$BASENAME" == .env.* ]]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked: sensitive file (.env)"}}'
fi
