#!/bin/bash
set -e

echo "[Q16] Installing gVisor (runsc) on node01..."
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
set -e
# Add gVisor repo
curl -fsSL https://gvisor.dev/archive.key | gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] \
  https://storage.googleapis.com/gvisor/releases release main" \
  > /etc/apt/sources.list.d/gvisor.list
apt-get update -qq
apt-get install -y runsc 2>/dev/null

# Configure containerd to use runsc
mkdir -p /etc/containerd
if [ -f /etc/containerd/config.toml ]; then
  grep -q "runsc" /etc/containerd/config.toml || cat >> /etc/containerd/config.toml << 'CONTAINERD'

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]
  runtime_type = "io.containerd.runsc.v1"
CONTAINERD
else
  containerd config default > /etc/containerd/config.toml
  cat >> /etc/containerd/config.toml << 'CONTAINERD'

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]
  runtime_type = "io.containerd.runsc.v1"
CONTAINERD
fi
systemctl restart containerd
echo "gVisor installed and containerd configured"
REMOTE

echo "[Q16] Deploying workloads..."
kubectl create namespace team-purple --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment untrusted-app \
  -n team-purple --image=nginx:1.24 2>/dev/null || true

echo "[Q16] Setup complete — gVisor ready on node01"
