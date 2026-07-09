## Step 1 – Inspect existing resources

```bash
kubectl get secret web-tls -n web
kubectl get svc web-svc -n web
kubectl get ingressclass
```

Confirm:
- Secret type should be `kubernetes.io/tls`
- IngressClass `nginx` should be available

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi vérifier le type du Secret ?**
`kubernetes.io/tls` impose la présence des clés `tls.crt` et `tls.key` — le contrôleur ingress-nginx les cherche à ces noms exacts. Un Secret `Opaque` créé avec `--from-file` peut contenir les mêmes données sous d'autres clés → l'ingress sert silencieusement le **certificat par défaut auto-signé** ("Kubernetes Ingress Controller Fake Certificate"). Pas d'erreur, juste un mauvais cert : failure mode silencieux typique.

**Pourquoi vérifier l'IngressClass ?** Sans `ingressClassName` correspondant à une classe existante, aucun contrôleur ne réconcilie votre Ingress — il reste ADDRESS vide pour toujours.

📚 Ressources :
- https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets
- https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class

</details>
