## Step 1 – Create the encryption config

Generate a 32-byte key:
```bash
KEY=$(head -c 32 /dev/urandom | base64)
echo "Your key: $KEY"  # save this
```

Create the config:
```bash
mkdir -p /etc/kubernetes/enc

cat > /etc/kubernetes/enc/enc.yaml << EOF
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
- resources:
  - secrets
  providers:
  - aescbc:
      keys:
      - name: key1
        secret: ${KEY}
  - identity: {}
EOF
```

> **⚠ Critical:** `aescbc` must be **FIRST** — the first provider encrypts new writes.
> `identity: {}` last = allows reading old unencrypted secrets.

---

<details>
<summary>💡 <b>Pourquoi ? — Raisonnement & ressources</b> (cliquer pour déplier)</summary>

**Pourquoi l'ordre des providers est LE point de la question ?**
Sémantique asymétrique : le **premier** provider chiffre les écritures ; la **liste entière** est essayée en lecture. Donc :
- `aescbc` en premier, `identity` en dernier = nouvelles écritures chiffrées + anciens secrets en clair encore lisibles → migration sans downtime.
- Ordre inversé = `identity` écrit tout en clair : la config "existe" mais ne protège rien. Faille silencieuse, zéro erreur.

**Pourquoi ce n'est pas suffisant en prod ?**
La clé AES vit en clair sur le disque du control plane, à côté d'etcd — on protège contre le vol du backup etcd, pas contre la compromission du node. Le niveau au-dessus : provider `kms` (clé dans Vault/AWS KMS, jamais sur le node). Tu as déjà la moitié du chemin avec ton Vault — le connecter en KMS provider serait un excellent sujet d'entretien.

📚 Ressources :
- https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/
- https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/

</details>
