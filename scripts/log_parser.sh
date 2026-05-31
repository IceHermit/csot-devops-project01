#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: $0 <access.log>"; exit 1; }
[[ $# -ne 1 ]] && usage
log="$1"
[[ ! -f "$log" ]] && { echo "Log not found: $log" >&2; exit 1; }

echo "=== Top 10 IPs ==="
awk '{print $1}' "$log" | sort | uniq -c | sort -rn | head -10

echo
echo "=== HTTP Status Distribution ==="
awk '{print $9}' "$log" | sort | uniq -c | sort -rn

echo
echo "=== Top 10 URLs ==="
awk '{print $7}' "$log" | sort | uniq -c | sort -rn | head -10

echo
echo "=== 4xx Errors ==="
awk '$9 ~ /^4/' "$log" | wc -l

echo "=== 5xx Errors ==="
awk '$9 ~ /^5/' "$log" | wc -l