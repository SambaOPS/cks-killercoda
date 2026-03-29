#!/bin/bash
f ! kubectl get ciliumnetworkpolicy backend-ingress -n mutual-auth &>/dev/null; then
  echo "FAIL: CiliumNetworkPolicy 'backend-ingress' not found in mutual-auth"
  exit 1
fi
POLICY=$(kubectl get ciliumnetworkpolicy backend-ingress -n mutual-auth -o json 2>/dev/null)
if ! echo "$POLICY" | grep -q '"required"'; then
  echo "FAIL: authentication.mode: required not found"
  exit 1
fi
if ! echo "$POLICY" | grep -q '"disabled"'; then
  echo "FAIL: authentication.mode: disabled not found"
  exit 1
fi
if ! echo "$POLICY" | grep -q '"host"'; then
  echo "FAIL: fromEntities host not found"
  exit 1
fi
echo "PASS: CiliumNetworkPolicy with mutual auth configured correctly"
exit 0
