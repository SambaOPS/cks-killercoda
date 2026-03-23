#!/bin/bash
# Deploy pre-state for Q01: Falco lab
kubectl create namespace production --dry-run=client -o yaml | kubectl apply -f -

for NAME in nvidia cpu ollama; do
  kubectl create deployment $NAME -n production --image=nginx:1.24 --replicas=1 2>/dev/null || true
done

# Ensure Falco is running
systemctl enable falco 2>/dev/null || true
systemctl start falco 2>/dev/null || true

# Ensure local rules file exists
touch /etc/falco/falco_rules.local.yaml
echo "Setup complete"