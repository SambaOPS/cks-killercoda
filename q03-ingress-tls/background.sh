#!/bin/bash
kubectl create namespace web --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment web-app -n web --image=nginx:1.24 2>/dev/null || true
kubectl expose deployment web-app -n web --name=web-svc --port=80 2>/dev/null || true
# Create self-signed TLS cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048   -keyout /tmp/tls.key -out /tmp/tls.crt   -subj "/CN=web.example.com" 2>/dev/null
kubectl create secret tls web-tls -n web   --cert=/tmp/tls.crt --key=/tmp/tls.key 2>/dev/null || true
echo "Setup complete"