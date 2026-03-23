#!/bin/bash
kubectl create namespace team-purple --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment untrusted-app -n team-purple --image=nginx:1.24 2>/dev/null || true
echo "Setup complete"