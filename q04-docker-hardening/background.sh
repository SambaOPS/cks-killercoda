#!/bin/bash
set -e

echo "[Q04] Setting up Docker daemon misconfigurations on node01..."
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
# Ensure docker is installed and running
which docker 2>/dev/null || apt-get install -y docker.io 2>/dev/null || true
systemctl start docker 2>/dev/null || true
systemctl enable docker 2>/dev/null || true

# Create 'develop' user and add to docker group
useradd develop 2>/dev/null || true
groupadd docker 2>/dev/null || true
usermod -aG docker develop 2>/dev/null || true

# Set socket to wrong owner
chown develop:docker /var/run/docker.sock 2>/dev/null || true

# Add TCP socket to ExecStart line (realistic format)
# Real docker.service ExecStart may vary — handle both cases
DOCKER_SERVICE="/lib/systemd/system/docker.service"
if [ -f "$DOCKER_SERVICE" ]; then
  if ! grep -q "tcp://0.0.0.0:2375" "$DOCKER_SERVICE"; then
    # Add -H tcp before -H fd or at end of ExecStart
    sed -i '/^ExecStart=.*dockerd/{s|ExecStart=/usr/bin/dockerd|ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375|}' \
      "$DOCKER_SERVICE" 2>/dev/null || true
  fi
  systemctl daemon-reload 2>/dev/null || true
  systemctl restart docker 2>/dev/null || true
fi
echo "node01 setup done"
REMOTE
echo "[Q04] Setup complete"
