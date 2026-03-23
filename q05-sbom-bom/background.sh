#!/bin/bash
kubectl create namespace sbom-test --dry-run=client -o yaml | kubectl apply -f -
cat <<EOF | kubectl apply -f - 2>/dev/null || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: alpine-app
  namespace: sbom-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: alpine-app
  template:
    metadata:
      labels:
        app: alpine-app
    spec:
      containers:
      - name: app-a
        image: alpine:3.20.0
        command: ["sleep", "3600"]
      - name: app-b
        image: alpine:3.19.6
        command: ["sleep", "3600"]
      - name: app-c
        image: alpine:3.16.1
        command: ["sleep", "3600"]
EOF
echo "Setup complete"