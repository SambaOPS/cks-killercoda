## Step 2 – Edit the kube-apiserver manifest

```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml{,.bak}
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

**1. APPEND** `ImagePolicyWebhook` to the existing `--enable-admission-plugins` flag:
```yaml
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
```

**2. Add** the admission config flag:
```yaml
- --admission-control-config-file=/etc/kubernetes/admission/admission-config.yaml
```

**3. Add** volumeMount:
```yaml
    - mountPath: /etc/kubernetes/admission
      name: admission-config
      readOnly: true
```

**4. Add** volume:
```yaml
  - name: admission-config
    hostPath:
      path: /etc/kubernetes/admission
      type: DirectoryOrCreate
```

> ⚠️ Do NOT create a second `--enable-admission-plugins` line — append to the existing one.

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi APPEND et pas remplacer `--enable-admission-plugins` ?**
Remplacer la valeur supprime `NodeRestriction` — un plugin de sécurité critique qui empêche un kubelet compromis de modifier les objets des autres nodes. Écraser un flag existant au lieu de l'étendre est l'erreur classique qui fait passer une question d'exam de "réussie" à "cluster affaibli". Réflexe : toujours `grep enable-admission` AVANT d'éditer.

**Pourquoi 4 modifications coordonnées ?**
Flag admission-config → pointe le fichier ; le fichier référence le kubeconfig du webhook ; les deux doivent être visibles DANS le container → volumeMount + volume hostPath. Une chaîne : un maillon manquant = apiserver en crash loop. Debug : `crictl ps -a && crictl logs <id>` — kubectl est mort à ce stade.

📚 Ressources :
- https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/
- https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/

</details>
