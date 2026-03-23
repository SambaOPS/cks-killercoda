#!/bin/bash
mkdir -p /etc/kubernetes/admission

cat > /etc/kubernetes/admission/admission-config.yaml << 'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/admission/kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: true
EOF

cat > /etc/kubernetes/admission/kubeconfig.yaml << 'EOF'
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: https://localhost:8080/image-policy
  name: image-policy
contexts:
- context:
    cluster: image-policy
    user: api-server
  name: image-policy
current-context: image-policy
preferences: {}
users:
- name: api-server
  user: {}
EOF

echo "Setup complete"