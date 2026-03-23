#!/bin/bash
set -e

echo "[Q13] Installing apparmor-utils on controlplane and node01..."
apt-get install -y apparmor-utils 2>/dev/null || true
ssh -o StrictHostKeyChecking=no node01 "apt-get install -y apparmor-utils 2>/dev/null || true" 2>/dev/null || true

echo "[Q13] Creating AppArmor profile on node01..."
ssh -o StrictHostKeyChecking=no node01 "mkdir -p /opt/course/q13" 2>/dev/null || true
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
cat > /opt/course/q13/profile << 'PROFILE'
#include <tunables/global>
profile cks-nginx-deny-write flags=(attach_disconnected) {
  #include <abstractions/base>
  file,
  # Deny all file writes
  deny /** w,
}
PROFILE
echo "Profile created on node01"
REMOTE

echo "[Q13] Setup complete"
