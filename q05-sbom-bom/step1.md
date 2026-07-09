## Step 1 – Find the vulnerable image

Check available images:
```bash
kubectl get deploy alpine-app -n sbom-test -o yaml | grep image
```

Scan each image for libcrypto3:
```bash
# Using trivy (always available)
trivy image --pkg-types os alpine:3.20.0 2>/dev/null | grep libcrypto3
trivy image --pkg-types os alpine:3.19.6 2>/dev/null | grep libcrypto3
trivy image --pkg-types os alpine:3.16.1 2>/dev/null | grep libcrypto3

# Or using bom (check first)
which bom && bom generate --image alpine:3.16.1 --format spdx 2>/dev/null | grep libcrypto3
```

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi chercher un package précis plutôt que "scanner" ?**
C'est le workflow réel d'une réponse à CVE (type Log4Shell) : une vulnérabilité tombe, la question n'est pas "mes images ont-elles des CVE ?" mais "**où** tourne le package X en version vulnérable ?". Le SBOM répond en secondes à cette question d'inventaire — sans SBOM, il faut re-scanner toutes les images sous pression d'incident.

**SBOM vs scan de vulnérabilités** : le SBOM (Syft/bom) = inventaire des composants, stable ; le scan (Trivy/Grype) = croisement inventaire × base CVE, dont le résultat change chaque jour sans que l'image change. Tu génères déjà des SBOM CycloneDX avec Syft dans ta chaîne supply chain — ici c'est le format SPDX, l'autre standard (Linux Foundation).

📚 Ressources :
- https://kubernetes-sigs.github.io/bom/
- https://trivy.dev/latest/docs/supply-chain/sbom/

</details>
