#!/usr/bin/env bash
set -euo pipefail

ts=$(date -Iseconds)

echo "=== HEALTH CHECK $ts ==="

echo "[hostname] $(hostname)"
echo "[uptime] $(uptime -p)"

echo "[load]"
cat /proc/loadavg

echo "[memory]"
free -h | grep -E '^Mem|^Swap'

echo "[disk]"
df -h --output=target,size,used,avail,pcent | grep -vE '^Filesystem|^tmpfs|^devtmpfs|^/dev/loop'

echo "[top-5-cpu]"
ps -eo pid,user,%cpu,%mem,cmd --sort=-%cpu | head -6

echo "[network]"
ip -brief addr | grep -v 'DOWN'

echo "=== END $ts ==="