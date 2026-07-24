#!/bin/bash
set -euxo pipefail
dnf -y update || yum -y update || true
dnf -y install nginx || yum -y install nginx || apt-get update && apt-get install -y nginx
cat >/usr/share/nginx/html/index.html <<EOF
<html><body><h1>three_tier_platform</h1><p>host=$(hostname)</p></body></html>
EOF
systemctl enable nginx
systemctl start nginx
