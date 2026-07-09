## Step 1 – Inspect the provided files

```bash
ls /etc/kubernetes/admission/
cat /etc/kubernetes/admission/admission-config.yaml
```

**Fix `defaultAllow` first:**
```bash
grep "defaultAllow" /etc/kubernetes/admission/admission-config.yaml
# If true, change to false:
sed -i 's/defaultAllow: true/defaultAllow: false/'   /etc/kubernetes/admission/admission-config.yaml
```

> **defaultAllow: false** = fail-closed = deny all images if backend is down.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Fail-open vs fail-closed — LA décision de la question :**
`defaultAllow: true` = si le webhook backend est injoignable, **toutes les images passent**. Un attaquant n'a qu'à DoS le backend pour désactiver votre supply chain security. `defaultAllow: false` = backend down → aucune image n'est admise : la sécurité tient, au prix de la disponibilité des déploiements.

C'est un arbitrage classique sécurité vs disponibilité : pour un contrôle de **sécurité**, fail-closed est la règle (un firewall qui crash ne doit pas devenir un câble droit). Pour un contrôle de **confort** (mutation de labels), fail-open (`failurePolicy: Ignore`) est acceptable. Ton Kyverno pose exactement le même choix via `failurePolicy` sur ses webhooks — tu l'as touché du doigt quand une admission Kyverno a bloqué ton helm upgrade ingress-nginx.

📚 Ressources :
- https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#imagepolicywebhook
- https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#failure-policy

</details>
