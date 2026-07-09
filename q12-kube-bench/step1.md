## Step 1 – Run kube-bench

```bash
kube-bench run --targets=master 2>/dev/null | grep -E "\[FAIL\]" | head -20
```

Or check specific IDs:
```bash
kube-bench run --check=1.2.1,1.2.12,1.2.16,1.2.19
```

Note the suggested remediations in the output — they tell you exactly what to change.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Qu'est-ce que kube-bench vérifie exactement ?**
L'implémentation du **CIS Kubernetes Benchmark** — le référentiel d'audit standard de l'industrie (celui que les auditeurs sécu/conformité utilisent). Chaque check a un ID (1.2.1 = section apiserver), un état PASS/FAIL/WARN, et surtout une **remédiation textuelle incluse dans l'output** : à l'exam comme en prod, lisez-la, elle donne le flag exact à changer.

**Pourquoi `--targets=master` ?** kube-bench a des profils par rôle (master, node, etcd) — lancer le mauvais profil sur le mauvais node donne des résultats non pertinents. Réflexe : identifier le rôle du node avant d'auditer.

📚 Ressources :
- https://github.com/aquasecurity/kube-bench
- https://www.cisecurity.org/benchmark/kubernetes

</details>
