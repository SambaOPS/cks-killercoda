## Step 2 – Upgrade on node01

SSH to node01:
```bash
ssh node01
sudo -i
```

Find the exact target version:
```bash
apt update
# Get the EXACT version string from apt (e.g. 1.32.1-1.1)
CTRL_VERSION=$(kubectl version --short 2>/dev/null | grep Server | awk '{print $3}' | tr -d 'v')
apt-cache madison kubeadm | grep $CTRL_VERSION
```

Upgrade kubeadm:
```bash
apt-mark unhold kubeadm
apt-get install -y kubeadm=<exact-version>   # from madison output
apt-mark hold kubeadm
kubeadm upgrade node
```

Upgrade kubelet and kubectl:
```bash
apt-mark unhold kubelet kubectl
apt-get install -y kubelet=<exact-version> kubectl=<exact-version>
apt-mark hold kubelet kubectl
systemctl daemon-reload
systemctl restart kubelet
exit && exit
```