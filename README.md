# Caddie

A mobile-first golf journal with KPIs, progress charts, and an AI coach (Claude) that knows your rounds, practice sessions, and lesson notes.

## Quick start

**Prerequisites:** Node.js 18+

```bash
npm install
cp .env.example .env
# Edit .env and set ANTHROPIC_API_KEY (from console.anthropic.com)

npm run dev
```

Open [http://localhost:3000](http://localhost:3000). The dev server proxies AI requests so your API key stays in `.env` instead of the browser.

## Using with Claude Code

This repo is set up for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and courses like **Claude Code in Action**:

```bash
cd /path/to/caddie
claude
```

Run `/init` if you want Claude to refresh `CLAUDE.md`. Project context lives in that file.

## API keys

| Mode | Where the key lives |
|------|---------------------|
| `npm run dev` | `.env` → `ANTHROPIC_API_KEY` |
| Static / deployed HTML | Settings ⚙️ in the app → localStorage |

GitHub Gist sync (optional backup) is always configured in the app Settings UI with a fine-grained token (`Gists: Read and write`).

## Sample data

Import `data/sample-sessions.json` via **Settings → Exportar datos** (export current), or paste into DevTools:

```js
localStorage.setItem('caddie_sessions_v1', JSON.stringify(/* paste sessions array */));
location.reload();
```

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start dev server on port 3000 |
| `npm start` | Same as `dev` |

## Files

- `index.html` — main app
- `server.js` — Express static server + `/api/messages` proxy
- `CLAUDE.md` — context for Claude Code agents
