## Step 1 – List and scan

List all unique images:
```bash
kubectl get pods -n prod \
  -o jsonpath='{range .items[*]}{range .spec.containers[*]}{.image}{"\n"}{end}{end}' | sort -u
```

Check if Trivy is available:
```bash
which trivy || ssh node01 which trivy
```

Scan each image:
```bash
trivy image --severity CRITICAL nginx:1.19.0
trivy image --severity CRITICAL redis:6.0.5
trivy image --severity CRITICAL alpine:3.12
```

> **⚠ Trap:** Trivy may only be installed on node01 — check both!

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi lister les images via jsonpath plutôt que `describe` ?**
51 pods à la main = erreurs garanties. Le jsonpath extrait la donnée exacte, `sort -u` déduplique — vous scannez chaque image UNE fois, pas chaque pod. Réflexe d'automatisation transposable partout (audit d'images dans ton cluster : même one-liner).

**Pourquoi `--severity CRITICAL` ?**
Un scan complet de nginx:1.19 sort des centaines de findings — inutilisable. Filtrer par sévérité = prioriser par risque. En prod, la politique typique : CRITICAL bloque le pipeline, HIGH génère un ticket, le reste est du bruit accepté. C'est exactement le seuil que tu configures dans tes gates Trivy Harbor.

**Le trap "trivy sur node01"** rappelle une réalité : les outils ne sont pas toujours sur le node où vous êtes. Toujours `which` avant de conclure "pas installé".

📚 Ressources :
- https://trivy.dev/latest/docs/scanner/vulnerability/
- https://kubernetes.io/docs/reference/kubectl/jsonpath/

</details>
