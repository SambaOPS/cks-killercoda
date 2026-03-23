## Step 1 – Fix the Dockerfile

```bash
cat /opt/course/q18/Dockerfile
```

Find `USER root` and change it to `USER nobody`:

```bash
sed -i 's/USER root/USER nobody/' /opt/course/q18/Dockerfile
grep "^USER" /opt/course/q18/Dockerfile
# → USER nobody
```

> **Do NOT rebuild the image** unless the question explicitly asks for it.