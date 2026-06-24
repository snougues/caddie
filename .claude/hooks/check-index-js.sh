#!/usr/bin/env bash
FILE=$(jq -r '.tool_input.file_path // ""')
if [[ "$FILE" == *index.html ]]; then
  INDEX_PATH="$FILE" node -e "
const fs = require('fs');
const h = fs.readFileSync(process.env.INDEX_PATH, 'utf8');
const matches = [...h.matchAll(/<script(?![^>]*\bsrc\b)[^>]*>([\s\S]*?)<\/script>/g)];
if (matches.length) {
  fs.writeFileSync('/tmp/caddie_check.js', matches.map(m => m[1]).join('\n'));
  process.exit(0);
}
process.exit(1);
" 2>/dev/null && node --check /tmp/caddie_check.js 2>&1 && echo 'JS OK' || echo 'JS syntax error in index.html — check output above'
fi
