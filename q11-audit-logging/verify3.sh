#!/bin/bash
leep 5  # Give API server time

# Check API server is running
if ! crictl ps 2>/dev/null | grep -q kube-apiserver; then
  # Try kubectl
  if ! kubectl get nodes &>/dev/null; then
    echo "FAIL: kube-apiserver appears to be down. Check: crictl logs \$(crictl ps -q --name kube-apiserver)"
    exit 1
  fi
fi

# Check policy file exists with correct content
if [ ! -f /etc/kubernetes/audit/audit-policy.yaml ]; then
  echo "FAIL: /etc/kubernetes/audit/audit-policy.yaml not found"
  exit 1
fi

if ! grep -q "level: None" /etc/kubernetes/audit/audit-policy.yaml; then
  echo "FAIL: audit policy missing 'level: None' catch-all rule"
  exit 1
fi

# Check API server has audit flags
if ! ps aux | grep kube-apiserver | grep -q "audit-policy-file"; then
  echo "FAIL: --audit-policy-file flag not found in kube-apiserver process"
  exit 1
fi

if ! ps aux | grep kube-apiserver | grep -q "audit-log-path"; then
  echo "FAIL: --audit-log-path flag not found in kube-apiserver process"
  exit 1
fi

# Check log directory exists
if [ ! -d /var/log/kubernetes/audit ]; then
  echo "FAIL: /var/log/kubernetes/audit directory not found"
  exit 1
fi

echo "PASS: Audit logging configured correctly"
exit 0
