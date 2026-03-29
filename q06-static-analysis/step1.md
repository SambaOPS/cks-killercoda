## Step 1 – Fix the Dockerfile (1 line)

```bash
cat /opt/course/q06/Dockerfile
# Find: USER root
```

Change **only** that line:
```bash
sed -i 's/^USER root/USER nobody/' /opt/course/q06/Dockerfile
grep '^USER' /opt/course/q06/Dockerfile
# → USER nobody ✅
```

> **⚠ Constraint:** Do NOT add extra lines or blocks — change the existing `USER` line only.
