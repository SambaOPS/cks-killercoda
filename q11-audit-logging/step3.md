## Step 3 – Verify

Wait for the API server to restart (~60s):
```bash
crictl ps | grep kube-apiserver
kubectl get nodes
```

Check the audit log is being written:
```bash
ls -la /var/log/kubernetes/audit/
tail -5 /var/log/kubernetes/audit/audit.log | python3 -m json.tool | head -20
```

Generate a test event:
```bash
kubectl get secret -n prod 2>/dev/null || true
tail -3 /var/log/kubernetes/audit/audit.log | grep -i secret
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi générer un événement de test ?**
"Le fichier existe" ≠ "l'audit fonctionne". On valide le pipeline de bout en bout : requête → règle matchée → ligne JSON écrite. C'est ton principe anti-normalisation de la déviance : un pipeline d'alerting/audit silencieux est un risque accumulé — tu l'as vécu avec ton Alertmanager SMTP muet.

**Réflexe prod** : en entreprise, ces audit logs partent vers un SIEM avec rétention réglementaire (PCI-DSS : 1 an). `--audit-log-maxbackup` et `maxage` ne sont pas cosmétiques : sans rotation, le disque du control plane se remplit et etcd tombe.

📚 Ressources :
- https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#audit-backends

</details>
