import express from 'express';
import Anthropic from '@anthropic-ai/sdk';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json({ limit: '1mb' }));
app.use(express.static(__dirname));

const anthropic = process.env.ANTHROPIC_API_KEY
  ? new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })
  : null;

app.get('/api/health', (_req, res) => {
  res.json({
    ok: true,
    anthropicConfigured: Boolean(anthropic),
  });
});

app.post('/api/messages', async (req, res) => {
  if (!anthropic) {
    return res.status(503).json({
      error: { message: 'ANTHROPIC_API_KEY not set. Copy .env.example to .env and add your key.' },
    });
  }

  try {
    const { model, max_tokens, system, messages } = req.body;
    const response = await anthropic.messages.create({
      model: model || 'claude-sonnet-4-20250514',
      max_tokens: max_tokens || 1024,
      ...(system ? { system } : {}),
      messages,
    });
    res.json(response);
  } catch (err) {
    const status = err.status || 500;
    res.status(status).json({
      error: { message: err.message || 'Anthropic API error' },
    });
  }
});

app.listen(PORT, () => {
  console.log(`Caddie dev server → http://localhost:${PORT}`);
  if (!anthropic) {
    console.warn('⚠  ANTHROPIC_API_KEY missing — copy .env.example to .env');
  }
});
