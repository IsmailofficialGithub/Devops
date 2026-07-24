#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/semver.sh"

PART="patch"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --part) PART="$2"; shift 2 ;;
    --help|-h) echo "Usage: bump.sh --part major|minor|patch"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
old="$(current_version)"
new="$(bump_semver "$old" "$PART")"
echo "$new" > "$VERSION_FILE"
log "bumped $old -> $new"
