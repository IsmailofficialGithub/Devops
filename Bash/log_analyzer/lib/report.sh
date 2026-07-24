#!/usr/bin/env bash
# report writers
# shellcheck shell=bash

write_md_report() {
  local out="$1" total="$2"
  {
    echo "# $REPORT_TITLE"
    echo
    echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo
    echo "## Summary"
    echo "- Total lines: **$total**"
    echo
    echo "## Status codes"
    echo '```'
    parse_status_counts "$INPUT_FILE"
    echo '```'
    echo
    echo "## Top IPs"
    echo '```'
    parse_top_ips "$INPUT_FILE" "$TOP_N"
    echo '```'
    echo
    echo "## Top paths"
    echo '```'
    parse_top_paths "$INPUT_FILE" "$TOP_N"
    echo '```'
    echo
    echo "## Methods"
    echo '```'
    parse_methods "$INPUT_FILE"
    echo '```'
    echo
    echo "## Error sample"
    echo '```'
    parse_error_lines "$INPUT_FILE" | head -n 20
    echo '```'
  } > "$out"
}

write_json_report() {
  local out="$1" total="$2"
  need python3
  python3 - "$INPUT_FILE" "$out" "$total" "$TOP_N" <<'PY'
import json, sys, collections, re
path, out, total, top_n = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
status=collections.Counter(); ips=collections.Counter(); paths=collections.Counter(); methods=collections.Counter()
err_re=re.compile(r"\b(5\d\d)\b")
errors=[]
with open(path, encoding="utf-8", errors="ignore") as f:
    for line in f:
        parts=line.split()
        if not parts: continue
        ips[parts[0]] += 1
        m=re.search(r'"(\w+)\s+([^"]+)\s+HTTP/[^"]+"\s+(\d{3})', line)
        if m:
            methods[m.group(1)] += 1
            paths[m.group(2).split("?")[0]] += 1
            status[m.group(3)] += 1
            if m.group(3).startswith("5"):
                errors.append(line.rstrip())
payload={
  "total_lines": total,
  "status_codes": status.most_common(),
  "top_ips": ips.most_common(top_n),
  "top_paths": paths.most_common(top_n),
  "methods": methods.most_common(),
  "errors_sample": errors[:20],
}
with open(out,"w",encoding="utf-8") as o:
    json.dump(payload,o,indent=2)
PY
}

write_html_report() {
  local out="$1" md_tmp
  md_tmp="$(mktemp)"
  write_md_report "$md_tmp" "$2"
  {
    echo "<!doctype html><html><head><meta charset=utf-8><title>$REPORT_TITLE</title>"
    echo "<style>body{font-family:system-ui;margin:2rem}pre{background:#111;color:#eee;padding:1rem;overflow:auto}</style>"
    echo "</head><body>"
    # minimal md->html (headers + pre blocks already in md as fenced)
    sed -e 's/^# \(.*\)/<h1>\1<\/h1>/' \
        -e 's/^## \(.*\)/<h2>\1<\/h2>/' \
        -e 's/^\- \(.*\)/<li>\1<\/li>/' \
        -e 's/^```/<pre>/' -e 's/^```$/<\/pre>/' "$md_tmp"
    echo "</body></html>"
  } > "$out"
  rm -f "$md_tmp"
}
