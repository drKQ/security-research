#!/bin/bash
# Run on or after 2026-08-21 00:00 UTC (CERT/CC embargo lift for VU#756733).
# Makes the repo public and turns on GitHub Pages.
set -e
echo "==> Making repo public..."
gh repo edit drKQ/security-research --visibility public --accept-visibility-change-consequences
echo "==> Enabling GitHub Pages (main branch, root)..."
gh api -X POST repos/drKQ/security-research/pages \
  -f 'source[branch]=main' -f 'source[path]=/' >/dev/null 2>&1 \
  || gh api -X PUT repos/drKQ/security-research/pages \
       -f 'source[branch]=main' -f 'source[path]=/' >/dev/null
echo "==> Waiting for first build..."
for i in $(seq 1 20); do
  s=$(gh api repos/drKQ/security-research/pages --jq .status 2>/dev/null || echo "null")
  echo "    status: $s"
  [ "$s" = "built" ] && break
  sleep 15
done
echo
echo "LIVE AT:"
echo "  https://drkq.github.io/security-research/calix-vu756733/"
