## Step 2 – Apply all required fields

```bash
vim /tmp/fix.yaml
```

Add to `spec.template.spec` (pod level):
```yaml
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        seccompProfile:
          type: RuntimeDefault
```

Add to `spec.template.spec.containers[0].securityContext`:
```yaml
        securityContext:
          allowPrivilegeEscalation: false
          privileged: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
            - ALL
```

```bash
kubectl apply -f /tmp/fix.yaml
kubectl rollout status deploy violating-app -n pss-fix
kubectl get pods -n pss-fix
# Should be Running ✅
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi certains champs au niveau pod et d'autres au niveau container ?**
- `seccompProfile`, `runAsNonRoot`, `runAsUser` : propriétés du *process model* → pod level (hérités par tous les containers, y compris init containers — piège fréquent).
- `capabilities`, `allowPrivilegeEscalation`, `readOnlyRootFilesystem` : propriétés *par container* → container level obligatoire.
Le container level override le pod level : un seul container avec `runAsUser: 0` casse la conformité de tout le pod.

**Pourquoi `seccompProfile` est le plus oublié ?**
Parce que le pod tourne très bien sans — la violation est invisible fonctionnellement. `RuntimeDefault` applique le filtre seccomp du runtime (~44 syscalls bloqués sur ~350) quasi sans risque de régression. Tu as déjà appliqué exactement ce durcissement sur ta platform-api (UID 1001, drop ALL, RO rootfs) — ici c'est la version "sous contrainte d'admission".

📚 Ressources :
- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
- https://kubernetes.io/docs/tutorials/security/seccomp/

</details>
