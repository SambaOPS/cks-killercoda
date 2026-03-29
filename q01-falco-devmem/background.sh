#!/bin/bash
set -e

echo "[Q01] Installing Falco..."
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc \
  | gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg 2>/dev/null
echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] \
  https://download.falco.org/packages/deb stable main" \
  > /etc/apt/sources.list.d/falcosecurity.list
apt-get update -qq
FALCO_FRONTEND=noninteractive apt-get install -y falco 2>/dev/null || \
  apt-get install -y --no-install-recommends falco 2>/dev/null

# Start Falco in modern mode (no kernel module needed)
systemctl enable falco-modern-bpf 2>/dev/null || true
systemctl start  falco-modern-bpf 2>/dev/null || \
  (systemctl enable falco && systemctl start falco) 2>/dev/null || true

# Create local rules file
mkdir -p /etc/falco
touch /etc/falco/falco_rules.local.yaml

echo "[Q01] Deploying workloads in namespace production..."
kubectl create namespace production --dry-run=client -o yaml | kubectl apply -f -
for NAME in nvidia cpu ollama; do
  kubectl create deployment $NAME \
    -n production --image=nginx:1.24 --replicas=1 2>/dev/null || true
done
kubectl run devmem-attacker -n production \
  --image=alpine --restart=Always \
  --overrides='{
    "spec": {
      "containers": [{
        "name":"attacker",
        "image":"alpine",
        "command":["sh","-c","while true; do cat /dev/mem 2>/dev/null; sleep 5; done"],
        "securityContext":{"privileged":true}
      }]
    }
  }' 2>/dev/null || true
echo "[Q01] Setup complete"
