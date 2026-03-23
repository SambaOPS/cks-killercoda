#!/bin/bash
set -e

echo "[Q23] Checking if Cilium CNI is present..."
if kubectl get pods -n kube-system 2>/dev/null | grep -q cilium; then
  echo "Cilium already installed"
else
  echo "[Q23] Installing Cilium CNI..."
  # Install Cilium CLI
  CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt 2>/dev/null || echo "v0.16.4")
  curl -sLo /tmp/cilium-linux-amd64.tar.gz \
    "https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-amd64.tar.gz"
  tar -xzf /tmp/cilium-linux-amd64.tar.gz -C /usr/local/bin
  chmod +x /usr/local/bin/cilium

  # Remove existing CNI
  rm -f /etc/cni/net.d/*.conf /etc/cni/net.d/*.conflist 2>/dev/null || true

  # Install Cilium
  cilium install --version 1.15.5 \
    --set authentication.mutual.spire.enabled=true \
    --set authentication.mutual.spire.install.enabled=true \
    2>/dev/null || cilium install --version 1.15.5 2>/dev/null || true

  cilium status --wait --timeout=3m 2>/dev/null || true
fi

echo "[Q23] Deploying workloads..."
kubectl create namespace mutual-auth --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace frontend-ns  --dry-run=client -o yaml | kubectl apply -f -

kubectl create deployment backend  -n mutual-auth --image=nginx:1.24 2>/dev/null || true
kubectl label deployment backend app=backend -n mutual-auth --overwrite 2>/dev/null || true
kubectl expose deployment backend -n mutual-auth --port=8080 --target-port=80 2>/dev/null || true

kubectl create deployment frontend -n frontend-ns --image=nginx:1.24 2>/dev/null || true
kubectl label deployment frontend app=frontend -n frontend-ns --overwrite 2>/dev/null || true

echo "[Q23] Setup complete"
