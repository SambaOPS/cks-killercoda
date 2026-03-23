#!/bin/bash
set -e

echo "[Q04] Setting up Docker daemon misconfigurations on node01..."
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
# Ensure docker group exists
groupadd docker 2>/dev/null || true

# Ensure docker is installed
which docker 2>/dev/null || apt-get install -y docker.io 2>/dev/null || true
systemctl start docker 2>/dev/null || true

# Create 'develop' user and add to docker group
useradd develop 2>/dev/null || true
usermod -aG docker develop 2>/dev/null || true

# Set socket to wrong owner
chown develop:docker /var/run/docker.sock 2>/dev/null || true

# Add TCP socket to docker service (if not already there)
if ! grep -q "tcp://0.0.0.0:2375" /lib/systemd/system/docker.service 2>/dev/null; then
  sed -i 's|ExecStart=/usr/bin/dockerd |ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 |' \
    /lib/systemd/system/docker.service 2>/dev/null || true
fi
systemctl daemon-reload 2>/dev/null || true
systemctl restart docker 2>/dev/null || true
echo "node01 Docker misconfigured"
REMOTE
echo "[Q04] Setup complete"
