#!/usr/bin/env bash
CMD=$(jq -r '.tool_input.command // ""')
if echo "$CMD" | grep -qE 'npm run dev|node server\.js'; then
  sleep 1 && open http://localhost:3000
fi
