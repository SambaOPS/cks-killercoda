#!/bin/bash
f ! kubectl get ingress web-ingress -n web &>/dev/null; then
  echo "FAIL: Ingress web-ingress not found in namespace web"
  exit 1
fi

SECRET=$(kubectl get ingress web-ingress -n web -o jsonpath='{.spec.tls[0].secretName}' 2>/dev/null)
if [ "$SECRET" != "web-tls" ]; then
  echo "FAIL: TLS secretName is '$SECRET', expected 'web-tls'"
  exit 1
fi

ANNOT=$(kubectl get ingress web-ingress -n web -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/ssl-redirect}' 2>/dev/null)
if [ "$ANNOT" != "true" ]; then
  echo "FAIL: ssl-redirect annotation missing or not 'true'"
  exit 1
fi

echo "PASS: Ingress web-ingress configured correctly with TLS and redirect"
exit 0
