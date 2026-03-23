#!/bin/bash
kubectl create namespace frontend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace backend --dry-run=client -o yaml | kubectl apply -f -

# Label namespaces (auto-label should be set, but ensure it)
kubectl label namespace frontend kubernetes.io/metadata.name=frontend --overwrite 2>/dev/null || true
kubectl label namespace backend kubernetes.io/metadata.name=backend --overwrite 2>/dev/null || true

# Deploy workloads
kubectl create deployment frontend -n frontend --image=nginx:1.24 2>/dev/null || true
kubectl label deployment frontend app=frontend -n frontend --overwrite 2>/dev/null || true

kubectl create deployment api -n backend --image=nginx:1.24 2>/dev/null || true
kubectl label deployment api app=api -n backend --overwrite 2>/dev/null || true

kubectl create deployment db -n backend --image=nginx:1.24 2>/dev/null || true
kubectl label deployment db app=db -n backend --overwrite 2>/dev/null || true
echo "Setup complete"