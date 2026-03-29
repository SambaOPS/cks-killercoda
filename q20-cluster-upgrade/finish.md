## Lab Complete! 🎉

### Upgrade sequence (memorize this)
1. `kubectl drain node01 --ignore-daemonsets --delete-emptydir-data`
2. SSH → unhold kubeadm → install → hold → `kubeadm upgrade node`
3. unhold kubelet kubectl → install → hold
4. `systemctl daemon-reload && restart kubelet`
5. `kubectl uncordon node01`

### Critical: `kubeadm upgrade node` ≠ `kubeadm upgrade apply`
- `upgrade node` = worker node
- `upgrade apply v<version>` = control plane only