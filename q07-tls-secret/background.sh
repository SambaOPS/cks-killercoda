#!/bin/bash
kubectl create namespace tls-test --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment secure-app -n tls-test --image=nginx:1.24 2>/dev/null || true
mkdir -p /opt/course/q07
openssl req -x509 -nodes -days 365 -newkey rsa:2048   -keyout /opt/course/q07/tls.key   -out /opt/course/q07/tls.crt   -subj "/CN=secure-app" 2>/dev/null
echo "Setup complete"