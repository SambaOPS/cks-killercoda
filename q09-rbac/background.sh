#!/bin/bash
kubectl create namespace rbac-test --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment api-server -n rbac-test --image=nginx:1.24 2>/dev/null || true
echo "Setup complete"