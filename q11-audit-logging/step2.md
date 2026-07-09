## Step 2 – Edit the kube-apiserver manifest

**Always backup first:**
```bash
cp /etc/kubernetes/manifests/kube-apiserver.yaml \
   /etc/kubernetes/manifests/kube-apiserver.yaml.bak
```

Edit the manifest:
```bash
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

Add these 4 flags to `spec.containers[0].command`:
```yaml
    - --audit-policy-file=/etc/kubernetes/audit/audit-policy.yaml
    - --audit-log-path=/var/log/kubernetes/audit/audit.log
    - --audit-log-maxbackup=2
    - --audit-log-maxage=30
```

Add to `spec.containers[0].volumeMounts`:
```yaml
    - mountPath: /etc/kubernetes/audit/audit-policy.yaml
      name: audit-policy
      readOnly: true
    - mountPath: /var/log/kubernetes/audit
      name: audit-log
      readOnly: false
```

Add to `spec.volumes`:
```yaml
  - name: audit-policy
    hostPath:
      path: /etc/kubernetes/audit/audit-policy.yaml
      type: File
  - name: audit-log
    hostPath:
      path: /var/log/kubernetes/audit
      type: DirectoryOrCreate
```

> **⚠ Don't wait!** Save the file and move to the next step. The API server restarts automatically in ~60s.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi backup le manifest AVANT ?**
Le kube-apiserver est un **static pod** : kubelet le recrée à chaque modification du fichier. Une typo = API server down = plus de `kubectl` pour réparer. Le backup + `crictl` (qui parle au runtime, pas à l'API) sont votre seule porte de sortie. À l'exam, un apiserver cassé peut coûter la question ET du temps sur toutes les suivantes.

**Pourquoi les volumeMounts sont-ils obligatoires ?**
Le apiserver tourne dans un container : il ne voit pas `/etc/kubernetes/audit` de l'hôte sans hostPath. Oublier le mount = crash loop avec `no such file or directory`. Diagnostic : `crictl ps -a` + `crictl logs`, jamais `kubectl logs` (l'API est down !).

**`type: File` vs `type: DirectoryOrCreate`** : on monte le fichier policy en `File` (fail-fast s'il manque) mais le répertoire de logs en `DirectoryOrCreate` (kubelet le crée si absent).

📚 Ressources :
- https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/
- https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#log-backend

</details>
