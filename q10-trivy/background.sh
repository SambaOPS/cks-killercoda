#!/bin/bash
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment web -n prod --image=nginx:1.19.0 2>/dev/null || true
kubectl create deployment cache -n prod --image=redis:6.0.5 2>/dev/null || true
kubectl create deployment monitor -n prod --image=alpine:3.12 2>/dev/null || true
echo "Setup complete"