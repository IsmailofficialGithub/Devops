#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"

MSG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --message) MSG="$2"; shift 2 ;;
    --help|-h) echo "Usage: changelog.sh --message \"text\""; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$MSG" ]] || die "--message required"
ver="$(current_version)"
tmp="$(mktemp)"
{
  echo "# Changelog"
  echo
  echo "## $ver"
  echo "- $MSG"
  echo
  # keep previous entries without duplicate top heading
  if [[ -f "$CHANGELOG_FILE" ]]; then
    tail -n +2 "$CHANGELOG_FILE" | sed '/^## '"$ver"'$/,/^## /{ /^## '"$ver"'$/d; /^## /!d; }' 2>/dev/null || true
    awk 'BEGIN{skip=0} /^# Changelog/{next} /^## '"$ver"'$/{skip=1; next} /^## /{skip=0} skip==0{print}' "$CHANGELOG_FILE"
  fi
} > "$tmp"
mv "$tmp" "$CHANGELOG_FILE"
log "changelog updated for $ver"
