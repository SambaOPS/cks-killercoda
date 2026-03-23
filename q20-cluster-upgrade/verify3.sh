#!/bin/bash
 Check node01 is Ready and not cordoned
STATUS=$(kubectl get node node01 --no-headers 2>/dev/null | awk '{print $2}')
if [ "$STATUS" != "Ready" ]; then
  echo "FAIL: node01 status is '$STATUS', expected 'Ready'"
  exit 1
fi

# Check versions match
CP_VERSION=$(kubectl get node controlplane --no-headers 2>/dev/null | awk '{print $5}')
NODE_VERSION=$(kubectl get node node01 --no-headers 2>/dev/null | awk '{print $5}')

if [ "$CP_VERSION" != "$NODE_VERSION" ]; then
  echo "FAIL: version mismatch — controlplane: $CP_VERSION, node01: $NODE_VERSION"
  exit 1
fi

echo "PASS: node01 upgraded successfully to $NODE_VERSION"
exit 0
