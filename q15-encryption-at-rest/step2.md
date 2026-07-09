## Step 2 – Configure API server

```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.bak}
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Add flag:
```yaml
- --encryption-provider-config=/etc/kubernetes/enc/enc.yaml
```

Add volumeMount:
```yaml
    - mountPath: /etc/kubernetes/enc
      name: enc-config
      readOnly: true
```

Add volume:
```yaml
  - name: enc-config
    hostPath:
      path: /etc/kubernetes/enc
      type: DirectoryOrCreate
```

Wait for restart, then re-encrypt existing secrets:
```bash
crictl ps | grep kube-apiserver   # wait for Running
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi le `kubectl replace` de tous les secrets ?**
Le chiffrement s'applique **à l'écriture**. Les secrets existants restent en clair dans etcd tant qu'ils ne sont pas réécrits. `get -o json | kubectl replace -f -` force une réécriture de chaque secret → chacun passe par le provider `aescbc`. Sans cette étape, l'audit de sécurité échoue : un `etcdctl get` montrerait encore du plaintext sur les anciens secrets.

**Réflexe rotation** : même mécanique pour la rotation de clé — ajouter `key2` en premier, replace all, puis retirer `key1`. Exactement la logique de tes rotations Vault : nouvelle credential d'abord, propagation, puis révocation de l'ancienne.

📚 Ressources :
- https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#ensure-all-secrets-are-encrypted
- https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#rotating-a-decryption-key

</details>
