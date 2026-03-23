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