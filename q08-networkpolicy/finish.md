## Lab Complete! 🎉

### The AND vs OR trap (most failed question)
```yaml
# AND — 1 dash — both conditions required:
from:
- namespaceSelector: {matchLabels: {ns: frontend}}
  podSelector: {matchLabels: {app: web}}

# OR — 2 dashes — either condition:
from:
- namespaceSelector: {matchLabels: {ns: frontend}}
- podSelector: {matchLabels: {app: web}}
```

### Key tips for the exam
- DNS egress **ALWAYS** needed after default-deny egress
- Namespace label: `kubernetes.io/metadata.name: <ns>`
- 1 dash = ET / 2 dashes = OU — single most common mistake