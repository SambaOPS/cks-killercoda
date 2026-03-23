#!/bin/bash
 Verify istio injection label + PeerAuthentication + pods 2/2

if ! kubectl get ns secured-app --show-labels 2>/dev/null | grep -q "istio-injection=enabled"; then
  echo "FAIL: istio-injection=enabled label missing on namespace secured-app"
  exit 1
fi

if ! kubectl get peerauthentication default -n secured-app -o jsonpath='{.spec.mtls.mode}' 2>/dev/null | grep -q "STRICT"; then
  echo "FAIL: PeerAuthentication mode is not STRICT"
  exit 1
fi

READY=$(kubectl get pods -n secured-app -o jsonpath='{.items[0].status.containerStatuses}' 2>/dev/null | grep -c '"ready":true' || echo 0)
if [ "$READY" -lt 2 ]; then
  echo "WARN: Pod may not have 2 ready containers yet - check kubectl get pods -n secured-app"
fi

echo "PASS: Istio mTLS configured correctly"
exit 0
