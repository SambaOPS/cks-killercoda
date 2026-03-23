#!/bin/bash
set -e

echo "[Q10] Installing trivy..."
apt-get install -y wget apt-transport-https gnupg 2>/dev/null || true
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
  | tee /etc/apt/sources.list.d/trivy.list
apt-get update -qq && apt-get install -y trivy 2>/dev/null

echo "[Q10] Deploying vulnerable workloads..."
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
kubectl create deployment web   -n prod --image=nginx:1.19.0 2>/dev/null || true
kubectl create deployment cache -n prod --image=redis:6.0.5  2>/dev/null || true
kubectl create deployment monitor -n prod --image=alpine:3.12 2>/dev/null || true

mkdir -p /opt/course/q10
echo "[Q10] Setup complete"
