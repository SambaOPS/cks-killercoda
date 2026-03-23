#!/bin/bash
leep 5

# Check API server is running
if ! kubectl get nodes &>/dev/null; then
  echo "FAIL: kubectl not responding — kube-apiserver may have crashed"
  echo "Check: crictl logs \$(crictl ps -q --name kube-apiserver)"
  exit 1
fi

ERRORS=0

# Check flags in running process
check_flag() {
  local flag="$1"
  local expected="$2"
  local cis_id="$3"
  if ! ps aux | grep kube-apiserver | grep -q "$flag=$expected"; then
    echo "FAIL [$cis_id]: $flag=$expected not active in kube-apiserver"
    ERRORS=$((ERRORS+1))
  fi
}

check_flag "--anonymous-auth" "false" "1.2.1"
check_flag "--profiling" "false" "1.2.12"
check_flag "--insecure-port" "0" "1.2.19"

if ! ps aux | grep kube-apiserver | grep -q "authorization-mode=Node,RBAC"; then
  echo "FAIL [1.2.16]: --authorization-mode=Node,RBAC not active"
  ERRORS=$((ERRORS+1))
fi

# Check file permissions
ETCD_OWNER=$(stat -c "%U:%G" /var/lib/etcd 2>/dev/null)
if [ "$ETCD_OWNER" != "etcd:etcd" ]; then
  echo "FAIL [1.1.12]: /var/lib/etcd owner is '$ETCD_OWNER', expected 'etcd:etcd'"
  ERRORS=$((ERRORS+1))
fi

KUBELET_PERM=$(stat -c "%a" /var/lib/kubelet/config.yaml 2>/dev/null)
if [ "$KUBELET_PERM" != "600" ]; then
  echo "FAIL [4.1.9]: /var/lib/kubelet/config.yaml permissions are '$KUBELET_PERM', expected '600'"
  ERRORS=$((ERRORS+1))
fi

[ $ERRORS -eq 0 ] && echo "PASS: All CIS benchmark fixes applied correctly" && exit 0
exit 1
