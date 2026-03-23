#!/bin/bash
kubectl create namespace hardening --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment webapp -n hardening --image=nginx:1.24 2>/dev/null || true

mkdir -p /opt/course/q18
cat > /opt/course/q18/Dockerfile << 'EOF'
FROM nginx:1.24
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
USER root
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
EOF
echo "Setup complete"