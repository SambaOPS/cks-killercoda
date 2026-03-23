#!/bin/bash
f ! kubectl get secret app-tls -n tls-test &>/dev/null; then
  echo "FAIL: Secret app-tls not found in namespace tls-test"
  exit 1
fi

SECRET_TYPE=$(kubectl get secret app-tls -n tls-test -o jsonpath='{.type}' 2>/dev/null)
if [ "$SECRET_TYPE" != "kubernetes.io/tls" ]; then
  echo "FAIL: Secret type is '$SECRET_TYPE', expected 'kubernetes.io/tls'"
  exit 1
fi

MOUNT=$(kubectl get deploy secure-app -n tls-test -o jsonpath='{.spec.template.spec.volumes}' 2>/dev/null)
if ! echo "$MOUNT" | grep -q "app-tls"; then
  echo "FAIL: Secret app-tls not mounted in Deployment"
  exit 1
fi

READONLY=$(kubectl get deploy secure-app -n tls-test -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[?(@.name=="tls-secret")].readOnly}' 2>/dev/null)
if [ "$READONLY" != "true" ]; then
  echo "WARN: readOnly not set to true on the volume mount"
fi

echo "PASS: TLS secret created and mounted correctly"
exit 0
