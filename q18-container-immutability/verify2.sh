#!/bin/bash
 Check Dockerfile
if ! grep -q "^USER nobody" /opt/course/q18/Dockerfile 2>/dev/null; then
  echo "FAIL: Dockerfile does not contain 'USER nobody'"
  exit 1
fi

# Check Deployment securityContext
SC=$(kubectl get deploy webapp -n hardening -o jsonpath='{.spec.template.spec.containers[0].securityContext}' 2>/dev/null)

if ! echo "$SC" | grep -q '"runAsUser":65535'; then
  echo "FAIL: runAsUser is not 65535"
  exit 1
fi

if ! echo "$SC" | grep -q '"readOnlyRootFilesystem":true'; then
  echo "FAIL: readOnlyRootFilesystem is not true"
  exit 1
fi

if ! echo "$SC" | grep -q '"allowPrivilegeEscalation":false'; then
  echo "FAIL: allowPrivilegeEscalation is not false"
  exit 1
fi

echo "PASS: Container immutability configured correctly"
exit 0
