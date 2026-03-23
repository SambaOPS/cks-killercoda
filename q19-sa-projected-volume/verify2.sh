#!/bin/bash
AUTOMOUNT=$(kubectl get sa api-sa -n token-test -o jsonpath='{.automountServiceAccountToken}' 2>/dev/null)
if [ "$AUTOMOUNT" != "false" ]; then
  echo "FAIL: SA api-sa automountServiceAccountToken is '$AUTOMOUNT', expected 'false'"
  exit 1
fi

VOLUMES=$(kubectl get deploy api-app -n token-test -o jsonpath='{.spec.template.spec.volumes}' 2>/dev/null)
if ! echo "$VOLUMES" | grep -q "projected"; then
  echo "FAIL: No projected volume found in Deployment api-app"
  exit 1
fi

EXPIRY=$(kubectl get deploy api-app -n token-test -o jsonpath='{.spec.template.spec.volumes[?(@.name=="api-token")].projected.sources[0].serviceAccountToken.expirationSeconds}' 2>/dev/null)
if [ "$EXPIRY" != "3600" ]; then
  echo "WARN: expirationSeconds is '$EXPIRY', expected '3600'"
fi

MOUNT=$(kubectl get deploy api-app -n token-test -o jsonpath='{.spec.template.spec.containers[0].volumeMounts}' 2>/dev/null)
if ! echo "$MOUNT" | grep -q "api-token"; then
  echo "FAIL: volumeMount for api-token not found"
  exit 1
fi

echo "PASS: ServiceAccount token security configured correctly"
exit 0
