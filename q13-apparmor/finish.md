## Lab Complete! 🎉

### Two syntax options
**K8s >= 1.30 (securityContext — preferred):**
```yaml
spec:
  securityContext:
    appArmorProfile:
      type: Localhost
      localhostProfile: <name-from-inside-file>
```

**Annotation (older syntax, still valid):**
```yaml
metadata:
  annotations:
    container.apparmor.security.beta.kubernetes.io/<container-name>: localhost/<profile-name>
```

### Key tips for the exam
- Profile name = inside the file, NOT the filename
- Container name in annotation must exactly match the spec
- `nodeName` required — profile is node-local