## Lab Complete! 🎉

### How ImagePolicyWebhook works
```
kubectl run pod --image=nginx:1.19
→ API Server → ImagePolicyWebhook admission plugin
→ HTTP POST to webhook backend: {image: "nginx:1.19"}
→ Backend responds: {allowed: true/false}
→ If backend DOWN + defaultAllow=false → DENIED
→ If backend DOWN + defaultAllow=true  → ALLOWED (insecure!)
```

### Key tips for the exam
- `defaultAllow: false` = deny when backend unreachable
- APPEND to existing `--enable-admission-plugins` — don't duplicate the flag
- Both the admission-config AND kubeconfig files need the volume mount