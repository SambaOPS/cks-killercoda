#!/bin/bash
f ! kubectl get ns team-red --show-labels 2>/dev/null | grep -q "pod-security.kubernetes.io/enforce=baseline"; then
  echo "FAIL: pod-security.kubernetes.io/enforce=baseline label missing from team-red"
  exit 1
fi

if kubectl get pod privileged-pod -n team-red &>/dev/null; then
  echo "FAIL: privileged-pod still exists — delete it with kubectl delete pod privileged-pod -n team-red"
  exit 1
fi

echo "PASS: PSS baseline enforced and non-compliant pod removed"
exit 0
