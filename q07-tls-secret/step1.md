## Step 1 – Create the TLS Secret

```bash
ls /opt/course/q07/
# tls.crt  tls.key

kubectl create secret tls app-tls \
  --cert=/opt/course/q07/tls.crt \
  --key=/opt/course/q07/tls.key \
  -n tls-test

kubectl get secret app-tls -n tls-test
# Type should be: kubernetes.io/tls
```

> **⚠ Trap:** Use `--cert` and `--key` flags — NOT `--from-file`.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `create secret tls` et pas `--from-file` ?**
Le sous-type `tls` fait trois choses que `generic --from-file` ne fait pas : il **valide** que cert et clé sont un PEM cohérent, il impose les noms de clés `tls.crt`/`tls.key`, et il type le Secret `kubernetes.io/tls` — le contrat attendu par ingress-nginx, cert-manager, et la plupart des contrôleurs. `--from-file=tls.crt` produirait des données identiques mais un type `Opaque` : certains consommateurs le refusent, d'autres échouent silencieusement.

**Rappel qui fâche** : un Secret K8s est du base64, pas du chiffrement. Sa vraie protection = RBAC + encryption at rest (q15) + éviter l'automount (q19). Chez toi, c'est SOPS+age côté Git et Vault côté runtime qui ferment la boucle.

📚 Ressources :
- https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets

</details>
