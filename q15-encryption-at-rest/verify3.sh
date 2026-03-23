#!/bin/bash
leep 5

if ! kubectl get nodes &>/dev/null; then
  echo "FAIL: API server not responding"
  exit 1
fi

if ! ps aux | grep kube-apiserver | grep -q "encryption-provider-config"; then
  echo "FAIL: --encryption-provider-config flag missing from kube-apiserver"
  exit 1
fi

if [ ! -f /etc/kubernetes/enc/enc.yaml ]; then
  echo "FAIL: /etc/kubernetes/enc/enc.yaml not found"
  exit 1
fi

# Check aescbc is first provider
FIRST=$(grep -A2 "providers:" /etc/kubernetes/enc/enc.yaml | grep -v "providers:" | head -1 | tr -d ' -')
if [ "$FIRST" != "aescbc:" ]; then
  echo "FAIL: First provider is not aescbc (got: $FIRST)"
  exit 1
fi

# Verify a secret is encrypted
kubectl create secret generic enc-verify-test --from-literal=key=value -n default &>/dev/null || true
ETCD_VAL=$(ETCDCTL_API=3 etcdctl   --cacert=/etc/kubernetes/pki/etcd/ca.crt   --cert=/etc/kubernetes/pki/etcd/server.crt   --key=/etc/kubernetes/pki/etcd/server.key   get /registry/secrets/default/enc-verify-test 2>/dev/null | head -c 50)

if echo "$ETCD_VAL" | grep -q "k8s:enc:aescbc"; then
  echo "PASS: Secrets are encrypted with aescbc in etcd"
  exit 0
else
  echo "FAIL: Secret not encrypted in etcd. Value starts with: $ETCD_VAL"
  exit 1
fi
