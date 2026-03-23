#!/bin/bash
kubectl create namespace pss-fix --dry-run=client -o yaml | kubectl apply -f -

# Apply restricted PSS label
kubectl label namespace pss-fix   pod-security.kubernetes.io/enforce=restricted   pod-security.kubernetes.io/warn=restricted   pod-security.kubernetes.io/enforce-version=latest   --overwrite 2>/dev/null || true

# Create a violating deployment
cat <<EOF | kubectl apply -f - 2>/dev/null || true
apiVersion: apps/v1
kind: Deployment
metadata:
  name: violating-app
  namespace: pss-fix
spec:
  replicas: 1
  selector:
    matchLabels:
      app: violating-app
  template:
    metadata:
      labels:
        app: violating-app
    spec:
      containers:
      - name: app
        image: nginx:1.24
        securityContext:
          privileged: true
          allowPrivilegeEscalation: true
EOF
echo "Setup complete"