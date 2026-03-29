#!/bin/bash
# Q17 – Kubelet hardening background setup

echo "[Q17] Setting up insecure kubelet config on node01..."
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
CONFIG="/var/lib/kubelet/config.yaml"
if [ -f "$CONFIG" ]; then
  # Set anonymous to true (insecure)
  if grep -q "anonymous:" "$CONFIG"; then
    sed -i '/anonymous:/,/enabled:/{s/enabled: false/enabled: true/}' "$CONFIG" 2>/dev/null || true
  else
    # Add authentication block if missing
    cat >> "$CONFIG" << 'YAML'
authentication:
  anonymous:
    enabled: true
  webhook:
    enabled: false
authorization:
  mode: AlwaysAllow
YAML
  fi

  # Set authorization mode to AlwaysAllow
  if grep -q "mode: Webhook" "$CONFIG"; then
    sed -i 's/mode: Webhook/mode: AlwaysAllow/' "$CONFIG" 2>/dev/null || true
  fi

  systemctl daemon-reload 2>/dev/null || true
  systemctl restart kubelet 2>/dev/null || true
  echo "Kubelet configured to insecure mode"
else
  echo "WARNING: $CONFIG not found"
fi
REMOTE
echo "[Q17] Setup complete"
