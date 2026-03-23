#!/bin/bash
f ! kubectl get pod apparmor-pod -n default &>/dev/null; then
  echo "FAIL: Pod apparmor-pod not found in namespace default"
  exit 1
fi

NODE=$(kubectl get pod apparmor-pod -n default -o jsonpath='{.spec.nodeName}' 2>/dev/null)
if [ "$NODE" != "node01" ]; then
  echo "FAIL: Pod is on '$NODE', expected 'node01'"
  exit 1
fi

PROFILE=$(kubectl get pod apparmor-pod -n default -o jsonpath='{.spec.securityContext.appArmorProfile.localhostProfile}' 2>/dev/null)
if [ -z "$PROFILE" ]; then
  PROFILE=$(kubectl get pod apparmor-pod -n default -o jsonpath='{.metadata.annotations}' 2>/dev/null | grep -o 'localhost/[^"]*' | head -1)
fi

if [ -z "$PROFILE" ]; then
  echo "FAIL: No AppArmor profile configured on the pod"
  exit 1
fi

echo "PASS: AppArmor profile '$PROFILE' applied to apparmor-pod"
exit 0
