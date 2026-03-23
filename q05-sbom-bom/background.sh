#!/bin/bash
set -e

echo "[Q05] Installing trivy..."
apt-get install -y wget apt-transport-https gnupg 2>/dev/null || true
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
  | tee /etc/apt/sources.list.d/trivy.list
apt-get update -qq && apt-get install -y trivy 2>/dev/null

echo "[Q05] Installing bom tool..."
BOM_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/bom/releases/latest \
  | grep tag_name | cut -d'"' -f4 | tr -d 'v' 2>/dev/null || echo "0.6.0")
curl -sLo /usr/local/bin/bom \
  "https://github.com/kubernetes-sigs/bom/releases/latest/download/bom-amd64-linux" \
  2>/dev/null || true
chmod +x /usr/local/bin/bom 2>/dev/null || true

echo "[Q05] Creating SBOM test deployment..."
kubectl create namespace sbom-test --dry-run=client -o yaml | kubectl apply -f -
cat <<YAML | kubectl apply -f - 2>/dev/null || true
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
YAML

mkdir -p /opt/course
echo "[Q05] Setup complete"
