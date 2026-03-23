## Lab Complete! 🎉

### Projected tokens vs old-style secret tokens
- **Old way:** Kubernetes created a Secret with the token (never expires, stored in etcd)
- **New way (projected):** Token is generated on-demand, bound to pod lifetime, auto-rotated

### Key tips for the exam
- Disable automount at BOTH SA level and pod spec level
- `expirationSeconds: 3600` = 1 hour
- `path: api-token` is the **filename** inside the `mountPath` directory