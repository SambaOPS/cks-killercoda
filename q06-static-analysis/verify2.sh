#!/bin/bash
if ! grep -q "^USER nobody" /opt/course/q06/Dockerfile 2>/dev/null; then
  echo "FAIL: Dockerfile does not contain 'USER nobody'"
  exit 1
fi
if grep -q "^USER root" /opt/course/q06/Dockerfile 2>/dev/null; then
  echo "FAIL: Dockerfile still contains 'USER root'"
  exit 1
fi
RO=$(kubectl get deploy static-app -n static-analysis   -o jsonpath='{.spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
if [ "$RO" != "true" ]; then
  echo "FAIL: readOnlyRootFilesystem is '$RO', expected 'true'"
  exit 1
fi
echo "PASS: Dockerfile and Deployment hardened correctly"
exit 0
