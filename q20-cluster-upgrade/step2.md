## Step 2 – Upgrade on node01

```bash
ssh node01
sudo -i

apt update
apt-cache madison kubeadm | grep 1.32
# Example output: kubeadm | 1.32.1-1.1 | ...

apt-mark unhold kubeadm
apt-get install -y kubeadm=1.32.1-1.1   # use exact version from madison
apt-mark hold kubeadm

# Worker node uses 'upgrade node', NOT 'upgrade apply'
kubeadm upgrade node

apt-mark unhold kubelet kubectl
apt-get install -y kubelet=1.32.1-1.1 kubectl=1.32.1-1.1
apt-mark hold kubelet kubectl

systemctl daemon-reload
systemctl restart kubelet
exit
exit
```