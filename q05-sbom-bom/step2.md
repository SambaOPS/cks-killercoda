## Step 2 – Fix the Deployment and generate report

Export and edit the Deployment:
```bash
kubectl get deploy alpine-app -n sbom-test -o yaml > /tmp/alpine-app.yaml
vim /tmp/alpine-app.yaml
```

Remove the container block using the vulnerable image (e.g., `alpine:3.16.1`).

Apply:
```bash
kubectl apply -f /tmp/alpine-app.yaml
kubectl rollout status deploy alpine-app -n sbom-test
```

Generate the SPDX report:
```bash
mkdir -p /opt/course

# Using trivy (most reliable):
trivy image --format spdx alpine:3.20.0 > /opt/course/sbom.spdx
# Verify
grep "SPDXVersion" /opt/course/sbom.spdx
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi retirer le container plutôt que patcher l'image ?**
À l'exam, le scope est dicté par l'énoncé : ici la remédiation demandée est le retrait. En prod, l'ordre de préférence serait : bump de version (3.16 → 3.20), rebuild, re-scan, redéploiement via pipeline — jamais d'édition live. Le retrait immédiat est le geste de *containment* quand le patch n'est pas disponible tout de suite.

**Pourquoi vérifier `SPDXVersion` ?** Un rapport SBOM vide ou tronqué (tag d'image mal orthographié, réseau) passe inaperçu à l'écriture du fichier. Toujours valider le contenu du livrable, pas seulement son existence — même réflexe que ton test de bout en bout sur l'audit log.

📚 Ressources :
- https://spdx.dev/learn/overview/
- https://trivy.dev/latest/docs/target/container_image/

</details>
