#!/bin/bash
 Verify: Falco rule exists + deployments scaled to 0

# Check rule in local rules file
if ! grep -q "fd.name = /dev/mem" /etc/falco/falco_rules.local.yaml 2>/dev/null; then
  echo "FAIL: Falco rule for /dev/mem not found in falco_rules.local.yaml"
  exit 1
fi

# Check output format
if ! grep -q "%evt.time,%container.id,%container.name,%user.name" /etc/falco/falco_rules.local.yaml 2>/dev/null; then
  echo "FAIL: Output format is incorrect"
  exit 1
fi

# Check deployments scaled to 0
for DEPLOY in nvidia cpu ollama; do
  REPLICAS=$(kubectl get deploy $DEPLOY -n production -o jsonpath='{.spec.replicas}' 2>/dev/null)
  if [ "$REPLICAS" != "0" ]; then
    echo "FAIL: Deployment $DEPLOY not scaled to 0 (replicas=$REPLICAS)"
    exit 1
  fi
done

echo "PASS: Falco rule correct and all deployments scaled to 0"
exit 0
