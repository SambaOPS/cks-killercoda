## Lab Complete! 🎉

### defaultAllow: false vs true
- `false` = fail-closed = deny when backend unreachable (secure)
- `true` = fail-open = allow when backend unreachable (insecure)

### Pattern volumeMount (same as Q11 audit + Q15 encryption)
Every file you add to the API server needs: flag + volumeMount + volume hostPath.