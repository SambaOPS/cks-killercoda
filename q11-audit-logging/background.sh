#!/bin/bash
set -e
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
# Pre-create directories so student doesn't get permission errors
mkdir -p /etc/kubernetes/audit
mkdir -p /var/log/kubernetes/audit
echo "[Q11] Setup complete"
