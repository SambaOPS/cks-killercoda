## Step 1 – Create the RuntimeClass

```bash
cat <<EOF | kubectl apply -f -
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
EOF
```

Verify:
```bash
kubectl get runtimeclass gvisor
```

> **⚠ Traps:**
> - No `namespace` on RuntimeClass — it's cluster-scoped
> - `apiVersion: node.k8s.io/v1` (GA), NOT `v1beta1`
> - `handler: runsc` (the binary), NOT `handler: gvisor`

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi gVisor, et que protège-t-il exactement ?**
Un container standard partage le **kernel de l'hôte** — chaque syscall du container frappe directement le vrai kernel : toute vuln kernel = escape potentiel. gVisor (runsc) intercale un kernel applicatif en userspace (Sentry) qui réimplémente les syscalls : le workload ne touche jamais le vrai kernel directement. Coût : ~10-20% de perf et une compatibilité syscall partielle — d'où son usage ciblé sur les workloads *untrusted* (code client, sandboxes CI), pas partout.

**Pourquoi `handler: runsc` ?** Le handler référence l'entrée configurée dans containerd (`plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc`) — c'est le nom côté runtime, pas un nom marketing. D'où le piège gvisor/runsc.

📚 Ressources :
- https://kubernetes.io/docs/concepts/containers/runtime-class/
- https://gvisor.dev/docs/

</details>
