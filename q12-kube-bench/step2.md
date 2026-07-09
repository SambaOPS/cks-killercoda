## Step 2 – Apply all fixes

**Backup first:**
```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.bak}
```

Edit the manifest:
```bash
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Find and set/update these flags (change existing values, don't add duplicates):
```yaml
- --anonymous-auth=false       # 1.2.1
- --profiling=false            # 1.2.12
- --authorization-mode=Node,RBAC  # 1.2.16 (was AlwaysAllow)
- --insecure-port=0            # 1.2.19
```

**File permission fixes:**
```bash
# 1.1.12 — etcd data directory
chown -R etcd:etcd /var/lib/etcd
stat -c "%U:%G" /var/lib/etcd

# 4.1.9 — kubelet config
chmod 600 /var/lib/kubelet/config.yaml
stat -c "%a" /var/lib/kubelet/config.yaml
```

> **⚠ Trap:** If `--authorization-mode` already exists with a wrong value, **change** it — don't add a second one. Two identical flags = crash.

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Le sens de chaque fix (pas juste le flag) :**
- `--anonymous-auth=false` : sans ça, des requêtes non authentifiées atteignent l'API en tant que `system:anonymous` — surface d'énumération gratuite.
- `--profiling=false` : les endpoints pprof exposent mémoire/CPU internes — fuite d'info + vecteur DoS.
- `--authorization-mode=Node,RBAC` : `AlwaysAllow` = **aucune autorisation du tout**, le RBAC entier est ignoré. Le fix le plus critique des quatre.
- `chmod 600` / `chown etcd:etcd` : etcd contient tous les Secrets ; la config kubelet contient ses paramètres d'auth. Lisibles par tous = compromission locale triviale.

**Le trap du flag dupliqué** : deux occurrences du même flag = le apiserver crash au démarrage (ou pire selon les versions, la dernière gagne silencieusement). Toujours `grep` le flag avant d'écrire. Et le backup du manifest reste votre assurance-vie (cf. q11).

📚 Ressources :
- https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/

</details>
