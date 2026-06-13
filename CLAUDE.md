# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Caddie

Personal golf tracking app with an AI coach powered by Claude. The main goal now is to use it in iOS.

## Stack

- **Frontend**: single-page app in `index.html` (vanilla JS, no build step)
- **Styling**: inline CSS in `<style>`, Tabler icons (CDN), Chart.js (CDN)
- **Data**: `localStorage` on the client; optional GitHub Gist sync
- **AI**: Anthropic Messages API (`claude-sonnet-4-20250514`) for coach chat and progress summaries
- **Dev server**: `server.js` (Express, ESM) proxies `/api/messages` so API keys stay in `.env`

## Commands

```bash
npm install
cp .env.example .env   # add ANTHROPIC_API_KEY
npm run dev            # http://localhost:3000
```

`caddie.html` is an older variant — `index.html` is the canonical file, always edit that one.

## Architecture

Everything lives in `index.html`. The `<script>` block at the bottom is structured in clearly-labelled sections with `// ─── SECTION NAME ───` comments.

### Global state

```js
sessions        // array of session objects, persisted to localStorage
focusConcepts   // string from last clase, shown on home and injected into coach prompt
apiKey          // Anthropic key (only used when not on localhost)
progressSummary // AI-generated progress text, cached in localStorage
chatHistory     // in-memory array of {role, content} for the coach conversation
gistToken / gistId  // GitHub Gist credentials for cloud sync
```

### localStorage keys

| Key | Holds |
|-----|-------|
| `caddie_sessions_v1` | sessions array (JSON) |
| `caddie_focus_v1`    | focusConcepts string |
| `caddie_apikey_v1`   | Anthropic API key |
| `caddie_progress_v1` | cached progress summary |
| `caddie_gist_token_v1` / `caddie_gist_id_v1` | Gist credentials |

### API routing

`useDevProxy()` returns `true` when `location.hostname` is `localhost` or `127.0.0.1`. In that case `anthropicMessages()` calls `/api/messages` (proxied by `server.js`). Otherwise it calls the Anthropic API directly from the browser using the stored key.

### Session types

Each session object has a `type` field: `ronda`, `practica`, or `clase`.

- `ronda`: `score`, `putts`, `fir`, `gir`
- `practica`: `foco` (focus text), `duracion`
- `clase`: `instructor`, `conceptos` (sets `focusConcepts` globally)

### AI features

- **Progress summary** (`generateProgressSummary`): called after every `saveSession()`. Uses `buildProgressPrompt()` which includes the last 15 rounds, 8 lessons, and 8 practice sessions. Cached in localStorage. Requires ≥2 sessions.
- **Coach chat** (`sendMessage`): uses `buildCoachSystem()` which injects `PLAYER_PROFILE` (hardcoded player bio at top of script) + `progressSummary` + `focusConcepts` + last 6 sessions as context. `chatHistory` is kept in memory (resets on `resetChat()`).

### Gist sync

`syncUp()` / `syncDown()` push/pull `{ _v, _ts, sessions, focusConcepts, progressSummary }` to a private GitHub Gist. `syncDown` merges by session `id` (additive only — no deletes from remote). Auto-sync runs on `load()` startup.

### Navigation

`navigate(id)` toggles `.active` on `.screen` and `.nav-item` elements. Screens: `home`, `log`, `history`, `coach`. No router library.

## Conventions

- UI copy is in Spanish (Rioplatense, "vos")
- Keep changes minimal — this is a single-file app; avoid introducing a bundler
- Match existing CSS variables (`--green`, `--gold`, `--cream`, `--cream-dark`, etc.)
- Test coach + progress summary after any API-related changes
- The `PLAYER_PROFILE` constant is a hardcoded player bio used in every coach system prompt — update it if the player profile changes

## Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `ANTHROPIC_API_KEY` | For dev server | Anthropic API key |
| `PORT` | No | Dev server port (default 3000) |
