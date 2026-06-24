#!/usr/bin/env bash
FILE=$(jq -r '.tool_input.file_path // ""')
if [[ "$FILE" == *server.js ]]; then
  pkill -f 'node server.js' 2>/dev/null || true
  sleep 0.5
  cd /Users/snougues/Projects/caddie && npm run dev &>/dev/null &
fi
