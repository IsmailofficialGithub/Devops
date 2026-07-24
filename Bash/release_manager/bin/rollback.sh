#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"

ENV_NAME=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) ENV_NAME="$2"; shift 2 ;;
    --help|-h) echo "Usage: rollback.sh --env <name>"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$ENV_NAME" ]] || die "--env required"
prev="$CURRENT_ENV_DIR/$ENV_NAME/previous"
[[ -f "$prev" ]] || die "no previous release for $ENV_NAME"
cp -f "$CURRENT_ENV_DIR/$ENV_NAME/current" "$CURRENT_ENV_DIR/$ENV_NAME/previous.rollback-backup" || true
cp -f "$prev" "$CURRENT_ENV_DIR/$ENV_NAME/current"
log "rolled back $ENV_NAME to previous artifact"
