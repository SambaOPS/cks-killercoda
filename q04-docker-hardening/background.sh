#!/bin/bash
# Setup misconfigurations on node01
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
# Create develop user
useradd develop 2>/dev/null || true
# Add to docker group
usermod -aG docker develop 2>/dev/null || true
# Set socket to wrong owner
chown develop:docker /var/run/docker.sock 2>/dev/null || true
# Add TCP socket to docker service
if ! grep -q "tcp://0.0.0.0:2375" /lib/systemd/system/docker.service 2>/dev/null; then
  sed -i 's|ExecStart=/usr/bin/dockerd|ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375|'     /lib/systemd/system/docker.service 2>/dev/null || true
fi
systemctl daemon-reload 2>/dev/null || true
echo "node01 setup done"
REMOTE
echo "Background setup complete"