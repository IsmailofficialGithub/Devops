#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"

ENV_NAME=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) ENV_NAME="$2"; shift 2 ;;
    --help|-h) echo "Usage: promote.sh --env <name>"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$ENV_NAME" ]] || die "--env required"
mkdir -p "$CURRENT_ENV_DIR/$ENV_NAME"
latest="$ARTIFACT_DIR/latest"
[[ -L "$latest" || -f "$latest" ]] || die "no artifact; run build.sh first"
target="$(readlink -f "$latest" 2>/dev/null || readlink "$latest")"
[[ -f "$ARTIFACT_DIR/$target" ]] && target="$ARTIFACT_DIR/$target"
[[ -f "$target" ]] || target="$ARTIFACT_DIR/$(basename "$(readlink "$latest")")"
[[ -f "$target" ]] || die "latest artifact missing"

# keep previous for rollback
if [[ -f "$CURRENT_ENV_DIR/$ENV_NAME/current" ]]; then
  cp -f "$CURRENT_ENV_DIR/$ENV_NAME/current" "$CURRENT_ENV_DIR/$ENV_NAME/previous"
fi
cp -f "$target" "$CURRENT_ENV_DIR/$ENV_NAME/current"
echo "$(basename "$target")" > "$CURRENT_ENV_DIR/$ENV_NAME/VERSION"
log "promoted $(basename "$target") -> $ENV_NAME"
