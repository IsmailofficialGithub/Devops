#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/retention.sh"

TARGET=""; DRY=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    --help|-h) echo "Usage: prune.sh --target <name> [--dry-run]"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -n "$TARGET" ]] || die "--target required"
resolve_target "$TARGET"
prune_target_dir "$(target_dir)" "$DRY"
