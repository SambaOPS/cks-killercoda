## Step 2 – Scale down vulnerable Deployments and save output

Create the output directory:
```bash
mkdir -p /opt/course/q10
```

Save the scan result for `nginx:1.19.0`:
```bash
trivy image --severity CRITICAL nginx:1.19.0 > /opt/course/q10/result.txt
cat /opt/course/q10/result.txt
```

Scale down any Deployment with CRITICAL CVEs:
```bash
# Find which deployments use which images
kubectl get deploy -n prod -o wide

# Scale down (example — use actual results from your scan)
kubectl scale deploy web -n prod --replicas=0
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi sauver le rapport AVANT de scaler ?**
Ordre forensique : le rapport est la preuve qui justifie l'action. En entreprise, ce fichier part dans le ticket d'incident / l'outil GRC. Scaler d'abord et scanner ensuite = agir sans trace de la justification.

**Pourquoi scale à 0 plutôt que delete ?** Même raisonnement que q01 : préservation de la spec pour investigation, réversibilité en une commande, compatibilité GitOps. Et surtout, la vraie remédiation viendra du pipeline (bump d'image + redéploiement) — le scale-down n'est que le containment.

📚 Ressources :
- https://trivy.dev/latest/docs/configuration/reporting/

</details>
