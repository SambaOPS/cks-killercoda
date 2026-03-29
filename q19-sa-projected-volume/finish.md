## Lab Complete! 🎉

### Key points
- Disable automount at **both** SA and pod spec level
- `path: api-token` = filename inside mountPath directory
- `expirationSeconds: 3600` = 1 hour
- Projected tokens are auto-rotated and not stored in etcd