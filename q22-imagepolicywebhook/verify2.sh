#!/bin/bash
leep 5
if ! kubectl get nodes &>/dev/null; then
  echo "FAIL: API server not responding"
  exit 1
fi
if ! ps aux | grep kube-apiserver | grep -q "ImagePolicyWebhook"; then
  echo "FAIL: ImagePolicyWebhook not in admission plugins"
  exit 1
fi
DEFAULT=$(grep "defaultAllow" /etc/kubernetes/admission/admission-config.yaml 2>/dev/null | awk '{print $2}')
if [ "$DEFAULT" != "false" ]; then
  echo "FAIL: defaultAllow is '$DEFAULT', must be 'false'"
  exit 1
fi
echo "PASS: ImagePolicyWebhook configured with defaultAllow: false"
exit 0
