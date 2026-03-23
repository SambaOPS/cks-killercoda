#!/bin/bash
set -e

echo "[Q02] Installing Istio..."
export ISTIO_VERSION=1.22.0
curl -sL https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh - 2>/dev/null
export PATH="$PWD/istio-${ISTIO_VERSION}/bin:$PATH"

# Install Istio with minimal profile
istioctl install --set profile=minimal -y 2>/dev/null || true
kubectl wait --for=condition=available --timeout=180s \
  deployment/istiod -n istio-system 2>/dev/null || true

echo "[Q02] Deploying workloads..."
kubectl create namespace secured-app --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment web-app \
  -n secured-app --image=nginx:1.24 --replicas=1 2>/dev/null || true

echo "[Q02] Setup complete"
