#!/bin/bash
 Run checks on node01 via kubectl debug or direct ssh
RESULT=$(ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
ERRORS=0

# Check 1: develop not in docker group
if grep "^docker:" /etc/group | grep -q "develop"; then
  echo "FAIL: develop is still in docker group"
  ERRORS=$((ERRORS+1))
fi

# Check 2: socket owned by root:root
OWNER=$(stat -c "%U:%G" /var/run/docker.sock 2>/dev/null)
if [ "$OWNER" != "root:root" ]; then
  echo "FAIL: docker.sock owner is '$OWNER', expected 'root:root'"
  ERRORS=$((ERRORS+1))
fi

# Check 3: no TCP socket in service
if grep -q "tcp://0.0.0.0" /lib/systemd/system/docker.service 2>/dev/null; then
  echo "FAIL: TCP socket still present in docker.service"
  ERRORS=$((ERRORS+1))
fi

if [ $ERRORS -eq 0 ]; then
  echo "PASS"
fi
REMOTE
)

if echo "$RESULT" | grep -q "FAIL"; then
  echo "$RESULT"
  exit 1
fi
echo "PASS: All Docker daemon hardening checks passed"
exit 0
