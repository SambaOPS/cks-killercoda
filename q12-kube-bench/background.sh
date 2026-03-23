#!/bin/bash
set -e

echo "[Q12] Installing kube-bench..."
KB_VERSION="0.9.4"
curl -sLo /tmp/kube-bench.tar.gz \
  "https://github.com/aquasecurity/kube-bench/releases/download/v${KB_VERSION}/kube-bench_${KB_VERSION}_linux_amd64.tar.gz"
tar -xzf /tmp/kube-bench.tar.gz -C /usr/local/bin kube-bench
chmod +x /usr/local/bin/kube-bench

# Download CIS config files kube-bench needs
curl -sLo /tmp/kube-bench-cfg.tar.gz \
  "https://github.com/aquasecurity/kube-bench/releases/download/v${KB_VERSION}/kube-bench_${KB_VERSION}_linux_amd64.tar.gz"
mkdir -p /etc/kube-bench
tar -xzf /tmp/kube-bench.tar.gz -C /etc/kube-bench 2>/dev/null || true

echo "[Q12] Introducing intentional CIS failures..."
# Backup
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.pristine} 2>/dev/null || true

# Wrong etcd directory ownership
chown -R root:root /var/lib/etcd 2>/dev/null || true

# Wrong kubelet config permissions
chmod 644 /var/lib/kubelet/config.yaml 2>/dev/null || true

echo "[Q12] Setup complete — kube-bench is ready"
