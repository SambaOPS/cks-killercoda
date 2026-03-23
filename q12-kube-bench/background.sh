#!/bin/bash
# Introduce intentional misconfigurations
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.pristine} 2>/dev/null || true

# These will be set wrong — student must fix them
# Most are already at wrong defaults in some setups
# We just ensure the test conditions

# Fix etcd ownership to wrong value
chown -R root:root /var/lib/etcd 2>/dev/null || true

# Fix kubelet config permissions
chmod 644 /var/lib/kubelet/config.yaml 2>/dev/null || true

echo "Setup complete — misconfigurations introduced"