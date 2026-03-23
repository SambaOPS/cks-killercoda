#!/bin/bash
kubectl create namespace secured-app --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment web-app -n secured-app --image=nginx:1.24 --replicas=1 2>/dev/null || true
echo "Setup complete"