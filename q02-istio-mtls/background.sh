#!/bin/bash
# Q02 – Istio mTLS background setup

echo "[Q02] Creating namespace and deployment first (independent of Istio install)..."
kubectl create namespace secured-app --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment web-app \
  -n secured-app --image=nginx:1.24 --replicas=1 2>/dev/null || true
kubectl wait --for=condition=available --timeout=60s \
  deployment/web-app -n secured-app 2>/dev/null || true

echo "[Q02] Installing Istio (this may take 3-4 minutes)..."
# Check if already installed
if kubectl get namespace istio-system &>/dev/null && \
   kubectl get deployment istiod -n istio-system &>/dev/null; then
  echo "Istio already installed, skipping install"
else
  ISTIO_VERSION=1.22.0
  curl -sL https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh - 2>/dev/null
  export PATH="$PWD/istio-${ISTIO_VERSION}/bin:$PATH"
  # Install minimal profile
  istioctl install --set profile=minimal -y 2>/dev/null || true
fi

# Wait for istiod (non-blocking - lab can proceed even if pending)
echo "[Q02] Waiting for istiod (up to 3 min)..."
kubectl wait --for=condition=available --timeout=180s \
  deployment/istiod -n istio-system 2>/dev/null || \
  echo "istiod not ready yet — lab can still proceed for PeerAuthentication steps"

echo "[Q02] Setup complete"
echo "[Q02] web-app deployment: $(kubectl get deploy web-app -n secured-app --no-headers 2>/dev/null || echo 'check manually')"
