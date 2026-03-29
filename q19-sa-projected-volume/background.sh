#!/bin/bash
kubectl create namespace token-test --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount api-sa -n token-test 2>/dev/null || true
kubectl create deployment api-app -n token-test --image=nginx:1.24 2>/dev/null || true
kubectl set serviceaccount deployment api-app api-sa -n token-test 2>/dev/null || true
echo "[Q19] Setup complete"