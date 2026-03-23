#!/bin/bash
# Copy profile to node01
ssh -o StrictHostKeyChecking=no node01 mkdir -p /opt/course/q13
ssh -o StrictHostKeyChecking=no node01 cat > /opt/course/q13/profile << 'EOF'
#include <tunables/global>
profile cks-nginx-deny-write flags=(attach_disconnected) {
  #include <abstractions/base>
  file,
  # Deny all file writes
  deny /** w,
}
EOF
echo "Setup complete"