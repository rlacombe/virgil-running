#!/bin/bash
# Switchback Running — multi-agent launcher
# Detects installed AI agents, remembers your preference, and launches
# with agent-appropriate configuration.

set -euo pipefail
cd "$(dirname "$0")" || exit 1

PREF_FILE=".switchback-agent"
SOUL_FILE="SOUL.md"

# ---- Agent detection ----

declare -a AVAILABLE=()
command -v claude &>/dev/null && AVAILABLE+=("claude")
command -v codex  &>/dev/null && AVAILABLE+=("codex")
command -v gemini &>/dev/null && AVAILABLE+=("gemini")

if [ ${#AVAILABLE[@]} -eq 0 ]; then
  echo "No supported agent found. Install one of:"
  echo "  Claude Code:  npm install -g @anthropic-ai/claude-code"
  echo "  Codex CLI:    npm install -g @openai/codex"
  echo "  Gemini CLI:   npm install -g @anthropic-ai/gemini-cli"
  exit 1
fi

# ---- Agent selection ----

AGENT=""

# 1. --agent flag takes priority
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent)  AGENT="$2"; shift 2 ;;
    --agent=*) AGENT="${1#*=}"; shift ;;
    *) ARGS+=("$1"); shift ;;
  esac
done

# 2. Saved preference (verify still installed)
if [ -z "$AGENT" ] && [ -f "$PREF_FILE" ]; then
  SAVED=$(tr -d '[:space:]' < "$PREF_FILE")
  if printf '%s\n' "${AVAILABLE[@]}" | grep -qx "$SAVED"; then
    AGENT="$SAVED"
  fi
fi

# 3. Only one agent available — use it
if [ -z "$AGENT" ] && [ ${#AVAILABLE[@]} -eq 1 ]; then
  AGENT="${AVAILABLE[0]}"
fi

# 4. Ask the user
if [ -z "$AGENT" ]; then
  echo "Multiple agents detected. Which would you like to use?"
  echo ""
  for i in "${!AVAILABLE[@]}"; do
    echo "  $((i+1))) ${AVAILABLE[$i]}"
  done
  echo ""
  read -rp "Pick a number (saved for next time): " choice
  idx=$((choice - 1))
  if [ "$idx" -ge 0 ] && [ "$idx" -lt ${#AVAILABLE[@]} ]; then
    AGENT="${AVAILABLE[$idx]}"
    echo "$AGENT" > "$PREF_FILE"
    echo "Saved: $AGENT"
  else
    echo "Invalid choice." >&2
    exit 1
  fi
fi

# Validate
if ! printf '%s\n' "${AVAILABLE[@]}" | grep -qx "$AGENT"; then
  echo "Agent '$AGENT' is not installed." >&2
  exit 1
fi

# ---- Launch ----

case "$AGENT" in
  claude)
    SOUL_FLAG=""
    if [ -f "$SOUL_FILE" ]; then
      SOUL_FLAG="--append-system-prompt-file $SOUL_FILE"
    fi
    exec claude $SOUL_FLAG --continue "Hey coach!"
    ;;

  codex)
    exec codex "Hey! Read SOUL.md and athlete/profile.md, then greet me and give me today's briefing."
    ;;

  gemini)
    exec gemini "Hey! Read SOUL.md and athlete/profile.md, then greet me and give me today's briefing."
    ;;
esac
