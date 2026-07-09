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

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `apt-mark hold/unhold` ?**
Sans hold, un `apt upgrade` de routine bumperait kubeadm/kubelet vers une version non planifiée — violation potentielle du **version skew** (kubelet ne doit jamais être plus récent que l'apiserver, et au max n-3 en retard). L'upgrade K8s est un acte chirurgical versionné, jamais un effet de bord du patching OS.

**Pourquoi `upgrade node` sur un worker et pas `upgrade apply` ?**
`apply` pilote l'upgrade du control plane (etcd, apiserver, migration des addons) ; `node` met seulement à jour la config kubelet locale depuis le cluster. Confondre les deux sur un worker échoue proprement, mais coûte du temps. Ordre global : control plane d'abord, workers ensuite, un par un.

📚 Ressources :
- https://kubernetes.io/releases/version-skew-policy/
- https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/upgrading-linux-nodes/

</details>
