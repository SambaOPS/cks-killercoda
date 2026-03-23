#!/bin/bash
set -e
mkdir -p /etc/kubernetes/enc
# Create a test secret that should be re-encrypted
kubectl create secret generic pre-existing-secret \
  --from-literal=password=cleartext123 -n default 2>/dev/null || true
echo "[Q15] Setup complete"
