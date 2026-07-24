#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/checks.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/actions.sh"

ensure_dirs
[[ -f "$CHECKS_FILE" ]] || die "missing $CHECKS_FILE"
failed=0
while IFS='|' read -r name type target action; do
  [[ "$name" =~ ^#.*$ || -z "$name" ]] && continue
  if run_check "$name" "$type" "$target"; then
    log "OK $name ($type)"
  else
    alert "FAIL $name type=$type target=$target"
    maybe_restart "$name" "${action:-none}" || true
    failed=$((failed+1))
  fi
done < "$CHECKS_FILE"
exit "$failed"
