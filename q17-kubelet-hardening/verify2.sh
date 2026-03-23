#!/bin/bash
 Check node is still Ready
if ! kubectl get node node01 --no-headers 2>/dev/null | grep -q "Ready"; then
  echo "FAIL: node01 is not Ready — kubelet may not have restarted correctly"
  exit 1
fi

# Check kubelet config on node01
RESULT=$(ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
ERRORS=0

ANON=$(grep -A2 "anonymous:" /var/lib/kubelet/config.yaml 2>/dev/null | grep "enabled:" | awk '{print $2}')
if [ "$ANON" != "false" ]; then
  echo "FAIL: anonymous.enabled is '$ANON', expected 'false'"
  ERRORS=$((ERRORS+1))
fi

MODE=$(grep "mode:" /var/lib/kubelet/config.yaml 2>/dev/null | grep -v "#" | head -1 | awk '{print $2}')
if [ "$MODE" != "Webhook" ]; then
  echo "FAIL: authorization.mode is '$MODE', expected 'Webhook'"
  ERRORS=$((ERRORS+1))
fi

[ $ERRORS -eq 0 ] && echo "PASS"
REMOTE
)

if echo "$RESULT" | grep -q "FAIL"; then
  echo "$RESULT"
  exit 1
fi

echo "PASS: Kubelet hardening configured correctly"
exit 0
