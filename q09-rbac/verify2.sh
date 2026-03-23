#!/bin/bash
f ! kubectl get sa api-sa -n rbac-test &>/dev/null; then
  echo "FAIL: ServiceAccount api-sa not found in rbac-test"
  exit 1
fi

AUTOMOUNT=$(kubectl get sa api-sa -n rbac-test -o jsonpath='{.automountServiceAccountToken}' 2>/dev/null)
if [ "$AUTOMOUNT" != "false" ]; then
  echo "FAIL: automountServiceAccountToken should be false, got '$AUTOMOUNT'"
  exit 1
fi

if ! kubectl get role api-role -n rbac-test &>/dev/null; then
  echo "FAIL: Role api-role not found"
  exit 1
fi

if ! kubectl get rolebinding api-rolebinding -n rbac-test &>/dev/null; then
  echo "FAIL: RoleBinding api-rolebinding not found"
  exit 1
fi

SA_NAME=$(kubectl get deploy api-server -n rbac-test -o jsonpath='{.spec.template.spec.serviceAccountName}' 2>/dev/null)
if [ "$SA_NAME" != "api-sa" ]; then
  echo "FAIL: Deployment api-server uses SA '$SA_NAME', expected 'api-sa'"
  exit 1
fi

CAN_GET=$(kubectl auth can-i get pods --as=system:serviceaccount:rbac-test:api-sa -n rbac-test 2>/dev/null)
if [ "$CAN_GET" != "yes" ]; then
  echo "FAIL: api-sa cannot get pods (expected yes)"
  exit 1
fi

CAN_DELETE=$(kubectl auth can-i delete pods --as=system:serviceaccount:rbac-test:api-sa -n rbac-test 2>/dev/null)
if [ "$CAN_DELETE" != "no" ]; then
  echo "FAIL: api-sa can delete pods (should be restricted)"
  exit 1
fi

echo "PASS: RBAC configuration is correct"
exit 0
