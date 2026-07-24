#!/bin/bash
# Profil model: Anthropic (Claude) — profil default.
# Sangu model-agnostik (ADR-016): ini SALAH SATU profil opsional,
# bukan keharusan untuk fase tertentu.
# Menghapus semua override env var provider lain.
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_AUTH_TOKEN
unset ANTHROPIC_MODEL
unset ANTHROPIC_DEFAULT_OPUS_MODEL
unset ANTHROPIC_DEFAULT_SONNET_MODEL
unset ANTHROPIC_DEFAULT_HAIKU_MODEL
unset CLAUDE_CODE_SUBAGENT_MODEL
echo "✓ Profil: Anthropic (Claude) — pakai API key Anthropic bawaan"
