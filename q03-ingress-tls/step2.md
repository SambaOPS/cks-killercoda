## Step 2 – Create the Ingress with TLS

> **✅ Doc autorisée pendant l'exam :** `https://kubernetes.github.io/ingress-nginx`
> Tu peux y chercher les annotations nginx (ssl-redirect, force-ssl-redirect, etc.)

Apply the Ingress:

```bash
kubectl apply -f - <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: web
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - web.example.com
    secretName: web-tls
  rules:
  - host: web.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
YAML
```

Verify:

```bash
kubectl get ingress web-ingress -n web
kubectl describe ingress web-ingress -n web | grep -E "TLS|Rules|Annotations"
```

> **Pièges à l'exam :**
> - ssl-redirect: "true" est une STRING avec guillemets — pas un boolean
> - spec.tls[].hosts[] doit correspondre EXACTEMENT à rules[].host
> - ingressClassName: nginx est obligatoire (K8s >= 1.22)
> - Toujours specifier le namespace : metadata.namespace: web

Click **Check** to validate.


---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `hosts` dans `tls` ET dans `rules` ?**
Le bloc `tls` pilote le SNI (quel cert servir pour quel hostname) ; `rules.host` pilote le routage HTTP. Ils sont indépendants : un host présent dans `rules` mais absent de `tls` sera servi avec le fake certificate. Les deux doivent matcher exactement.

**`ssl-redirect` vs `force-ssl-redirect`** : `ssl-redirect: "true"` redirige 308 vers HTTPS *si un bloc TLS existe pour le host* (c'est déjà le défaut global d'ingress-nginx) ; `force-ssl-redirect` force même sans TLS configuré (cas TLS terminé en amont, ex. ton Cloudflare Tunnel). Sur ton homelab, cert-manager ajoute juste l'annotation `cert-manager.io/cluster-issuer` et remplit le Secret automatiquement — ici on fait la partie manuelle que cert-manager t'épargne.

📚 Ressources :
- https://kubernetes.github.io/ingress-nginx/user-guide/tls/ (doc autorisée à l'exam !)
- https://kubernetes.io/docs/concepts/services-networking/ingress/#tls

</details>
