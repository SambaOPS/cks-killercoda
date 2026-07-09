## Step 2 – Create the pod with AppArmor enforcement

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-pod
  namespace: default
spec:
  nodeName: node01
  securityContext:
    appArmorProfile:
      type: Localhost
      localhostProfile: cks-nginx-deny-write
  containers:
  - name: nginx
    image: nginx:1.24
EOF
```

Verify:
```bash
kubectl get pod apparmor-pod
kubectl describe pod apparmor-pod | grep -i apparmor
```

Test enforcement (the profile denies writes):
```bash
kubectl exec apparmor-pod -- touch /tmp/test-write 2>&1
# → Permission denied ✅ (profile is working)
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `securityContext.appArmorProfile` et plus l'annotation ?**
Jusqu'à K8s 1.30, AppArmor se configurait via l'annotation `container.apparmor.security.beta.kubernetes.io/<container>`. Depuis 1.30 (GA), c'est un champ typé du `securityContext` — validé par l'API server, donc les typos échouent à l'apply au lieu d'être silencieusement ignorées. **À l'exam 2025+, utilisez le champ ; sachez lire l'annotation dans du legacy.** C'est un pattern général : les annotations "beta" migrent vers des champs first-class (même trajectoire que seccomp).

**`type: Localhost`** = profil chargé sur le node (vs `RuntimeDefault` = profil du container runtime). Si le profil n'est pas chargé sur le node ciblé → le pod reste bloqué : c'est fail-closed, par design.

📚 Ressources :
- https://kubernetes.io/docs/tutorials/security/apparmor/#securing-a-pod
- https://kubernetes.io/blog/2024/04/22/apparmor-grad/ (GA en 1.30, migration annotation → champ)

</details>
