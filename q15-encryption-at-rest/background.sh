#!/bin/bash
echo "Environment ready for encryption lab"
kubectl create namespace enc-test --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true