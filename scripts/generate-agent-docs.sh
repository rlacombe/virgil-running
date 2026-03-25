#!/bin/bash
# Generates CLAUDE.md, AGENTS.md, and GEMINI.md from COMPANION.md + agent appendices
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f COMPANION.md ]; then
  echo "Error: COMPANION.md not found" >&2
  exit 1
fi

for agent in claude codex gemini; do
  appendix="agents/${agent}.md"
  if [ ! -f "$appendix" ]; then
    echo "Warning: $appendix not found, skipping" >&2
    continue
  fi

  case "$agent" in
    claude) output="CLAUDE.md" ;;
    codex)  output="AGENTS.md" ;;
    gemini) output="GEMINI.md" ;;
  esac

  {
    echo "<!-- Generated from COMPANION.md + agents/${agent}.md — do not edit directly -->"
    echo ""
    cat COMPANION.md
    echo ""
    echo ""
    cat "$appendix"
  } > "$output"

  echo "Generated $output"
done
