#!/bin/bash
 Check pods are running
RUNNING=$(kubectl get pods -n pss-fix --no-headers 2>/dev/null | grep Running | wc -l)
if [ "$RUNNING" -lt 1 ]; then
  echo "FAIL: No running pods in pss-fix namespace"
  kubectl describe rs -n pss-fix 2>/dev/null | grep -A5 "Warning" || true
  exit 1
fi

# Check key securityContext fields
SC=$(kubectl get deploy violating-app -n pss-fix -o jsonpath='{.spec.template.spec.containers[0].securityContext}' 2>/dev/null)

if ! echo "$SC" | grep -q '"allowPrivilegeEscalation":false'; then
  echo "FAIL: allowPrivilegeEscalation not false"
  exit 1
fi

CAP=$(kubectl get deploy violating-app -n pss-fix -o jsonpath='{.spec.template.spec.containers[0].securityContext.capabilities.drop}' 2>/dev/null)
if ! echo "$CAP" | grep -q "ALL"; then
  echo "FAIL: capabilities.drop does not include ALL"
  exit 1
fi

SECCOMP=$(kubectl get deploy violating-app -n pss-fix -o jsonpath='{.spec.template.spec.securityContext.seccompProfile.type}' 2>/dev/null)
if [ "$SECCOMP" != "RuntimeDefault" ]; then
  echo "FAIL: seccompProfile.type is '$SECCOMP', expected 'RuntimeDefault'"
  exit 1
fi

echo "PASS: Deployment is compliant with restricted PSS"
exit 0
