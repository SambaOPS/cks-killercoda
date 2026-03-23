#!/bin/bash
# Ensure node01 kubelet is in insecure state
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
if [ -f /var/lib/kubelet/config.yaml ]; then
  sed -i 's/enabled: false/enabled: true/' /var/lib/kubelet/config.yaml 2>/dev/null || true
  sed -i 's/mode: Webhook/mode: AlwaysAllow/' /var/lib/kubelet/config.yaml 2>/dev/null || true
  systemctl daemon-reload 2>/dev/null || true
  systemctl restart kubelet 2>/dev/null || true
fi
REMOTE
echo "Setup complete"