## Step 2 – Add projected token to Deployment

```bash
kubectl get deploy api-app -n token-test -o yaml > /tmp/api-app.yaml
vim /tmp/api-app.yaml
```

Add to `spec.template.spec`:
```yaml
      automountServiceAccountToken: false
```

Add to `containers[0].volumeMounts`:
```yaml
        - name: api-token
          mountPath: /var/run/secrets/tokens
          readOnly: true
```

Add to `spec.volumes`:
```yaml
      - name: api-token
        projected:
          sources:
          - serviceAccountToken:
              path: api-token
              expirationSeconds: 3600
```

```bash
kubectl apply -f /tmp/api-app.yaml
kubectl exec deploy/api-app -n token-test -- ls /var/run/secrets/tokens/
# → api-token ✅
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi un projected token plutôt que l'automount classique ?**
Trois propriétés que le token legacy n'a pas :
1. **`expirationSeconds`** : token à durée de vie courte, régénéré par kubelet — un token volé expire au lieu d'être valable à vie.
2. **`audience`** : le token n'est valide QUE pour le service cible (bound audience) — inutilisable contre l'API server si l'audience est différente.
3. **Bound au pod** : le token meurt avec le pod.

C'est exactement la philosophie de tes credentials dynamiques Vault : durée courte + scope étroit + rotation automatique, au lieu d'un secret statique éternel. Ton auth JWT GitLab CI → Vault utilise d'ailleurs le même mécanisme (tokens SA projetés avec audience).

📚 Ressources :
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#launch-a-pod-using-service-account-token-projection
- https://kubernetes.io/docs/concepts/storage/projected-volumes/#serviceaccounttoken

</details>
