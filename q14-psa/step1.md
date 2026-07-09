## Step 1 – Apply PSS and clean up

```bash
kubectl label namespace team-red \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/warn=baseline \
  pod-security.kubernetes.io/enforce-version=latest

# Verify
kubectl get ns team-red --show-labels | grep pod-security
```

> **⚠ Critical trap:** `enforce` does NOT evict existing non-compliant pods.
> You must delete them manually.

Delete the non-compliant pod:
```bash
kubectl delete pod privileged-pod -n team-red
kubectl get pods -n team-red
```

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi PSA n'évince pas les pods existants ?**
Design volontaire : PSA est un **admission controller** — il juge les requêtes API entrantes, pas l'état existant. Évincer automatiquement au moment où on pose un label serait un outage instantané sur tout le namespace. K8s vous laisse le contrôle du séquencement : labeliser en `warn`/`audit` d'abord, observer, puis `enforce` et nettoyer manuellement. C'est la même philosophie que le mode `Audit` avant `Enforce` de tes policies Kyverno.

**Les trois modes** : `enforce` (rejette), `warn` (message au client kubectl), `audit` (annotation dans l'audit log). En migration prod, on met `enforce=baseline` + `warn=restricted` : on bloque le pire tout en voyant ce qui casserait au niveau supérieur.

📚 Ressources :
- https://kubernetes.io/docs/concepts/security/pod-security-admission/
- https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/

</details>
