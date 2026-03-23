#!/bin/bash
f [ ! -f /opt/course/sbom.spdx ]; then
  echo "FAIL: /opt/course/sbom.spdx not found"
  exit 1
fi

if ! grep -q "SPDXVersion" /opt/course/sbom.spdx 2>/dev/null; then
  echo "FAIL: File does not appear to be in SPDX format (missing SPDXVersion)"
  exit 1
fi

CONTAINERS=$(kubectl get deploy alpine-app -n sbom-test -o jsonpath='{.spec.template.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$CONTAINERS" -ge 3 ]; then
  echo "FAIL: Deployment still has 3 containers — remove the vulnerable one"
  exit 1
fi

echo "PASS: Vulnerable container removed and SPDX report generated"
exit 0
