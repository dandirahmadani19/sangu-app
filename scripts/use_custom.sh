#!/bin/bash
# Template profil model generik untuk provider Anthropic-compatible.
# Sangu model-agnostik (ADR-016). Cara pakai:
#   1. Salin: cp scripts/use_custom.sh scripts/use_<provider>.sh
#   2. Isi nilai <...> di bawah.
#   3. source scripts/use_<provider>.sh
#
# Syarat: provider MUST menyediakan endpoint kompatibel Messages API
# Anthropic (Claude Code CLI bicara lewat protokol itu). Contoh yang
# punya: DeepSeek; gateway seperti LiteLLM / OpenRouter. Google Gemini
# TIDAK punya endpoint Anthropic-native — arahkan ANTHROPIC_BASE_URL ke
# gateway (mis. LiteLLM) yang menerjemahkan Anthropic <-> Gemini.
export ANTHROPIC_BASE_URL=<https://endpoint-provider/anthropic>
export ANTHROPIC_AUTH_TOKEN=<API key provider>
export ANTHROPIC_MODEL=<nama-model-utama>
export ANTHROPIC_DEFAULT_OPUS_MODEL=<nama-model-kuat>
export ANTHROPIC_DEFAULT_SONNET_MODEL=<nama-model-menengah>
export ANTHROPIC_DEFAULT_HAIKU_MODEL=<nama-model-cepat>
export CLAUDE_CODE_SUBAGENT_MODEL=<nama-model-cepat>
echo "✓ Profil: custom"
