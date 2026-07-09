## Step 3 – Verify in etcd

Create a test secret:
```bash
kubectl create secret generic enc-test \
  --from-literal=password=mysupersecret -n default
```

Read directly from etcd:
```bash
ETCDCTL_API=3 etcdctl \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  get /registry/secrets/default/enc-test | hexdump -C | head -3
```

**Expected:** First bytes should be `k8s:enc:aescbc:v1:key1` — NOT plaintext.

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi vérifier dans etcd et pas via kubectl ?**
`kubectl get secret` déchiffre toujours (l'API server fait la traduction) — il montrera le même résultat chiffré ou pas. La **seule** preuve est la lecture brute d'etcd : le préfixe `k8s:enc:aescbc:v1:key1` confirme le provider ET la clé utilisée. Règle générale d'ingénierie : valider au niveau où la garantie est censée exister, pas au niveau au-dessus.

**Les 3 flags TLS etcdctl** : etcd exige mTLS client — c'est aussi un rappel que quiconque possède ces certs lit tout etcd. La protection des certs `/etc/kubernetes/pki/etcd/` est aussi critique que le chiffrement lui-même.

📚 Ressources :
- https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#verifying-that-data-is-encrypted

</details>
