#!/bin/bash
kubectl create namespace static-analysis --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /opt/course/q06

cat > /opt/course/q06/Dockerfile << 'EOF'
FROM nginx:1.24
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
USER root
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > /opt/course/q06/deploy.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: static-app
  namespace: static-analysis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: static-app
  template:
    metadata:
      labels:
        app: static-app
    spec:
      containers:
      - name: app
        image: nginx:1.24
        securityContext:
          readOnlyRootFilesystem: false
          privileged: false
EOF
echo "[Q06] Setup complete"
