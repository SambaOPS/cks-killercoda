## Step 1 – Run kube-bench

```bash
kube-bench run --targets=master 2>/dev/null | grep -E "\[FAIL\]" | head -20
```

Or check specific IDs:
```bash
kube-bench run --check=1.2.1,1.2.12,1.2.16,1.2.19
```

Note the suggested remediations in the output — they tell you exactly what to change.