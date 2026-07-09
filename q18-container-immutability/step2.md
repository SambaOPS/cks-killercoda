## Step 2 – Fix the Deployment

```bash
kubectl get deploy webapp -n hardening -o yaml > /tmp/webapp.yaml
vim /tmp/webapp.yaml
```

Find the container spec and set/add the securityContext:

```yaml
        securityContext:
          runAsUser: 65535
          readOnlyRootFilesystem: true
          privileged: false
          allowPrivilegeEscalation: false
```

Apply:
```bash
kubectl apply -f /tmp/webapp.yaml
kubectl rollout status deploy webapp -n hardening
```

Verify:
```bash
# Should fail with Read-only file system
kubectl exec -n hardening deploy/webapp -- touch /test 2>&1
# → touch: cannot touch '/test': Read-only file system ✅

# Should show uid=65535
kubectl exec -n hardening deploy/webapp -- id
# → uid=65535(nobody) ✅
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi uid 65535 précisément ?**
Convention "nobody" : uid maximal historique, aucun droit, aucun home, aucun fichier possédé. N'importe quel uid non-root non-système (>10000) ferait l'affaire — l'important est `runAsUser` explicite + `runAsNonRoot` implicite. Ta platform-api utilise uid 1001 : même principe, autre convention.

**Pourquoi les DEUX vérifications exec ?**
`touch /test` → prouve le rootfs read-only ; `id` → prouve l'uid effectif. Chaque contrôle de sécurité mérite sa preuve directe et indépendante — une seule vérification laisse l'autre propriété supposée. C'est la version manuelle de ce que tes tests d'admission automatisent.

📚 Ressources :
- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

</details>
