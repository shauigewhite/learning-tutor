#!/bin/bash
#
# Post-session hook: reminds the user if learning profiles weren't updated.
# Works with any project — locates the memory directory relative to the
# project's .claude/ path rather than hardcoding a specific user path.
#

# Derive the project memory directory from the current working directory.
# Claude Code sets CWD to the project root when running hooks.
PROJECT_SLUG=$(echo "$PWD" | sed 's|[/:\\]|-|g; s|^-||')
MEMORY_DIR="$HOME/.claude/projects/${PROJECT_SLUG}/memory/learn"
MARKER="$HOME/.claude/projects/${PROJECT_SLUG}/.learning-session"

# Only check if a learning session was active
[ ! -f "$MARKER" ] && exit 0

DOMAIN=$(cat "$MARKER")
rm -f "$MARKER"

TODAY=$(date +%Y-%m-%d)
warnings=()

# Check plan file
PLAN_FILE="$MEMORY_DIR/${DOMAIN}-plan.md"
if [ -f "$PLAN_FILE" ]; then
  plan_mod_date=$(date -r "$PLAN_FILE" +%Y-%m-%d 2>/dev/null)
  if [ "$plan_mod_date" != "$TODAY" ]; then
    warnings+=("learning plan (${DOMAIN}-plan.md)")
  fi
fi

# Check progress file
PROGRESS_FILE="$MEMORY_DIR/${DOMAIN}.md"
if [ -f "$PROGRESS_FILE" ]; then
  progress_mod_date=$(date -r "$PROGRESS_FILE" +%Y-%m-%d 2>/dev/null)
  if [ "$progress_mod_date" != "$TODAY" ]; then
    warnings+=("progress file (${DOMAIN}.md)")
  fi
fi

if [ ${#warnings[@]} -gt 0 ]; then
  IFS=', '
  echo "⚠️ Learning tutor reminder: ${warnings[*]} not updated today — please update before ending the session!"
fi
