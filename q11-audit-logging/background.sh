#!/bin/bash
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
echo "Setup complete"