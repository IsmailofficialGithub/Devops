#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/common.sh"

A=""; B=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --a) A="$2"; shift 2 ;;
    --b) B="$2"; shift 2 ;;
    --help|-h) echo "Usage: diff_inventory.sh --a old.json --b new.json"; exit 0 ;;
    *) die "unknown: $1" ;;
  esac
done
[[ -f "$A" && -f "$B" ]] || die "--a and --b required"
python3 - "$A" "$B" <<'PY'
import json,sys
a=json.load(open(sys.argv[1],encoding="utf-8"))
b=json.load(open(sys.argv[2],encoding="utf-8"))
keys=["cpu_cores","memory_mb","disks","ips","ports","packages_sample","docker"]
print(f"diff {a.get('hostname')} @ {a.get('collected_at')} -> {b.get('collected_at')}")
for k in keys:
  if a.get(k)!=b.get(k):
    print(f"CHANGED {k}")
    if isinstance(a.get(k), list):
      sa,sb=set(a.get(k) or []), set(b.get(k) or [])
      for x in sorted(sb-sa): print(f"  + {x}")
      for x in sorted(sa-sb): print(f"  - {x}")
    else:
      print(f"  {a.get(k)} -> {b.get(k)}")
  else:
    print(f"same {k}")
PY
