#!/bin/bash
kubectl create namespace team-red --dry-run=client -o yaml | kubectl apply -f -
cat <<EOF | kubectl apply -f - 2>/dev/null || true
apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
  namespace: team-red
spec:
  containers:
  - name: nginx
    image: nginx:1.24
    securityContext:
      privileged: true
EOF
echo "Setup complete"