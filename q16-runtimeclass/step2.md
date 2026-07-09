## Step 2 – Update the Deployment

```bash
kubectl patch deploy untrusted-app -n team-purple --type=json -p='[
  {"op":"add","path":"/spec/template/spec/runtimeClassName","value":"gvisor"},
  {"op":"add","path":"/spec/template/spec/nodeName","value":"node01"}
]'

kubectl rollout status deploy untrusted-app -n team-purple
```

Verify gVisor is running:
```bash
kubectl exec -n team-purple deploy/untrusted-app -- dmesg | head -3
# → Starting gVisor...
```

Click **Check** to validate.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi `dmesg` comme preuve ?**
Dans un container standard, `dmesg` montre le ring buffer du **kernel hôte** (ou est bloqué). Sous gVisor, il montre le boot du kernel Sentry ("Starting gVisor...") — c'est la preuve directe que les syscalls passent par la sandbox. Vérifier au niveau où la garantie existe (même principe que le check etcd de q15).

**Pourquoi `nodeName: node01` ici ?** runsc n'est installé que sur node01 dans ce lab. En prod, on ne pinne jamais par nodeName : on labelise les nodes équipés et RuntimeClass porte un `scheduling.nodeSelector` qui route automatiquement les pods sandboxés vers les bons nodes.

📚 Ressources :
- https://kubernetes.io/docs/concepts/containers/runtime-class/#scheduling

</details>
