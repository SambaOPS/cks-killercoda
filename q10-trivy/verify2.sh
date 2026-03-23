#!/bin/bash
f [ ! -f /opt/course/q10/result.txt ]; then
  echo "FAIL: /opt/course/q10/result.txt not found"
  exit 1
fi

if [ ! -s /opt/course/q10/result.txt ]; then
  echo "FAIL: /opt/course/q10/result.txt is empty"
  exit 1
fi

echo "PASS: Trivy scan saved to /opt/course/q10/result.txt"
exit 0
