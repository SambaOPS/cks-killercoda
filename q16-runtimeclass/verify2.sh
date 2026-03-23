#!/bin/bash
f ! kubectl get runtimeclass gvisor &>/dev/null; then
  echo "FAIL: RuntimeClass 'gvisor' not found"
  exit 1
fi

HANDLER=$(kubectl get runtimeclass gvisor -o jsonpath='{.handler}' 2>/dev/null)
if [ "$HANDLER" != "runsc" ]; then
  echo "FAIL: RuntimeClass handler is '$HANDLER', expected 'runsc'"
  exit 1
fi

RT=$(kubectl get deploy untrusted-app -n team-purple -o jsonpath='{.spec.template.spec.runtimeClassName}' 2>/dev/null)
if [ "$RT" != "gvisor" ]; then
  echo "FAIL: Deployment runtimeClassName is '$RT', expected 'gvisor'"
  exit 1
fi

echo "PASS: RuntimeClass gVisor configured correctly"
exit 0
