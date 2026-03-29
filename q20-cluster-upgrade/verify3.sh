#!/bin/bash
STATUS=$(kubectl get node node01 --no-headers 2>/dev/null | awk '{print $2}')
if [ "$STATUS" != "Ready" ]; then
  echo "FAIL: node01 status is '$STATUS', expected 'Ready'"
  exit 1
fi
echo "PASS: node01 is Ready"
exit 0
