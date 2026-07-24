#!/bin/bash
# Profil model: DeepSeek (endpoint Anthropic-compatible) — opsional.
# Sangu model-agnostik (ADR-016): boleh dipakai fase APA PUN
# (Plan/Execute/Verify), bukan hanya Execute.
# Isi <DeepSeek API Key kamu> sebelum `source`.
export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_AUTH_TOKEN=<DeepSeek API Key kamu>
export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
echo "✓ Profil: DeepSeek V4"
