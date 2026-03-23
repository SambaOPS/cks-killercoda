## Lab Complete! 🎉

### Upgrade order (always follow this sequence)
1. `kubectl drain node01 --ignore-daemonsets --delete-emptydir-data`
2. SSH → `apt-mark unhold kubeadm` → install → hold
3. `kubeadm upgrade node` (NOT `upgrade apply` — that's for control plane)
4. `apt-mark unhold kubelet kubectl` → install → hold
5. `systemctl daemon-reload && systemctl restart kubelet`
6. `kubectl uncordon node01`

### Key tips for the exam
- `apt-cache madison kubeadm | grep <version>` for exact version string
- Worker nodes use `kubeadm upgrade node` (no version argument)
- Control plane uses `kubeadm upgrade apply v<version>`