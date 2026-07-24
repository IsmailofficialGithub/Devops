#!/usr/bin/env bash
# shellcheck shell=bash

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' <<<"$1"
}

write_inventory_json() {
  local out="$1"
  need_py(){ command -v python3 >/dev/null 2>&1 || die "python3 required for JSON"; }
  need_py
  local host os cpu mem
  host="${HOSTNAME_OVERRIDE:-$(hostname)}"
  os="$(collect_os)"
  cpu="$(collect_cpu)"
  mem="$(collect_mem_mb)"
  local disks ips ports pkgs docker
  disks="$(collect_disks)"
  ips="$(collect_ips)"
  ports="$(collect_ports)"
  pkgs="$(collect_packages_sample)"
  docker="$(collect_docker)"
  HOST="$host" OS="$os" CPU="$cpu" MEM="$mem" \
  DISKS="$disks" IPS="$ips" PORTS="$ports" PKGS="$pkgs" DOCKER="$docker" \
  python3 - "$out" <<'PY'
import json, os, sys
out=sys.argv[1]
payload={
  "hostname": os.environ.get("HOST"),
  "collected_at": __import__("datetime").datetime.utcnow().isoformat()+"Z",
  "os": os.environ.get("OS","").split("|"),
  "cpu_cores": int(os.environ.get("CPU") or 0),
  "memory_mb": int(float(os.environ.get("MEM") or 0)),
  "disks": os.environ.get("DISKS","").splitlines(),
  "ips": os.environ.get("IPS","").splitlines(),
  "ports": os.environ.get("PORTS","").splitlines(),
  "packages_sample": os.environ.get("PKGS","").splitlines(),
  "docker": os.environ.get("DOCKER","").splitlines(),
}
with open(out,"w",encoding="utf-8") as f:
  json.dump(payload,f,indent=2)
PY
}

write_inventory_md() {
  local input="$1" out="$2"
  python3 - "$input" "$out" <<'PY'
import json,sys
data=json.load(open(sys.argv[1],encoding="utf-8"))
lines=[
  f"# Inventory: {data.get('hostname')}",
  "",
  f"- Collected: `{data.get('collected_at')}`",
  f"- OS: `{data.get('os')}`",
  f"- CPU cores: **{data.get('cpu_cores')}**",
  f"- Memory MB: **{data.get('memory_mb')}**",
  "",
  "## Disks",
  "```",
  *data.get("disks",[]),
  "```",
  "",
  "## IPs",
  "```",
  *data.get("ips",[]),
  "```",
  "",
  "## Ports",
  "```",
  *data.get("ports",[]),
  "```",
  "",
  "## Packages (sample)",
  "```",
  *data.get("packages_sample",[]),
  "```",
  "",
  "## Docker",
  "```",
  *data.get("docker",[]),
  "```",
]
open(sys.argv[2],"w",encoding="utf-8").write("\n".join(lines)+"\n")
PY
}
