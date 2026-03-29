#!/bin/bash
AUTOMOUNT=$(kubectl get sa api-sa -n token-test -o jsonpath='{.automountServiceAccountToken}' 2>/dev/null)
if [ "$AUTOMOUNT" != "false" ]; then
  echo "FAIL: SA api-sa automountServiceAccountToken is '$AUTOMOUNT', expected 'false'"
  exit 1
fi
VOLS=$(kubectl get deploy api-app -n token-test -o jsonpath='{.spec.template.spec.volumes}' 2>/dev/null)
if ! echo "$VOLS" | grep -q "projected"; then
  echo "FAIL: No projected volume found in Deployment api-app"
  exit 1
fi
echo "PASS: ServiceAccount token security configured correctly"
exit 0
