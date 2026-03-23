#!/bin/bash
 Check default-deny-all exists
if ! kubectl get networkpolicy default-deny-all -n backend &>/dev/null; then
  echo "FAIL: default-deny-all NetworkPolicy missing in namespace backend"
  exit 1
fi

POLICY_TYPES=$(kubectl get networkpolicy default-deny-all -n backend -o jsonpath='{.spec.policyTypes}' 2>/dev/null)
if ! echo "$POLICY_TYPES" | grep -q "Ingress" || ! echo "$POLICY_TYPES" | grep -q "Egress"; then
  echo "FAIL: default-deny-all must have both Ingress and Egress policyTypes"
  exit 1
fi

# Check allow policy exists
if ! kubectl get networkpolicy allow-frontend-to-api -n backend &>/dev/null; then
  echo "FAIL: allow-frontend-to-api NetworkPolicy missing"
  exit 1
fi

# Check DNS policy
if ! kubectl get networkpolicy allow-dns-egress -n backend &>/dev/null; then
  echo "FAIL: allow-dns-egress NetworkPolicy missing in backend"
  exit 1
fi

echo "PASS: NetworkPolicies configured correctly"
exit 0
