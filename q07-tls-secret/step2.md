## Step 2 – Mount the secret in the Deployment

```bash
kubectl get deploy secure-app -n tls-test -o yaml > /tmp/secure-app.yaml
vim /tmp/secure-app.yaml
```

Add to `spec.template.spec.containers[0].volumeMounts`:
```yaml
        volumeMounts:
        - name: tls-secret
          mountPath: /etc/tls
          readOnly: true     # ← obligatoire pour les certs TLS
```

Add to `spec.template.spec.volumes`:
```yaml
      volumes:
      - name: tls-secret
        secret:
          secretName: app-tls
```

Apply and verify:
```bash
kubectl apply -f /tmp/secure-app.yaml
kubectl rollout status deploy secure-app -n tls-test
kubectl exec -n tls-test deploy/secure-app -- ls /etc/tls
# → tls.crt  tls.key
```

> **⚠ readOnly: true est obligatoire** — un pod ne devrait jamais écrire dans ses propres certificats TLS.

Click **Check** to validate.


---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi monter en volume plutôt qu'en variables d'env ?**
Trois raisons : (1) les env vars fuitent facilement (`kubectl describe`, logs de crash, `/proc/<pid>/environ`, héritées par les child process) ; (2) un volume Secret est mis à jour **à chaud** par kubelet quand le Secret change (rotation de cert sans restart — clé pour cert-manager) ; une env var est figée au démarrage ; (3) les libs TLS attendent des chemins de fichiers.

**Pourquoi `readOnly: true` obligatoire ?** Un process compromis ne doit pas pouvoir remplacer son propre certificat/clé — sinon il peut se ré-identifier ou casser la chaîne de confiance. Les credentials sont consommés, jamais modifiés par le workload.

📚 Ressources :
- https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod

</details>
