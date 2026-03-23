#!/bin/bash
kubectl create namespace mutual-auth --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace frontend-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment backend -n mutual-auth --image=nginx:1.24 2>/dev/null || true
kubectl label deployment backend app=backend -n mutual-auth --overwrite 2>/dev/null || true
kubectl create deployment frontend -n frontend-ns --image=nginx:1.24 2>/dev/null || true
kubectl label deployment frontend app=frontend -n frontend-ns --overwrite 2>/dev/null || true
echo "Setup complete"