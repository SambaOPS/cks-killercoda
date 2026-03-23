## Lab Complete! 🎉

### The encryption rule
```
providers order = encryption order
FIRST provider → encrypts NEW writes
ALL providers → can decrypt reads
```

### Key tips for the exam
- `aescbc` MUST be first or new secrets are stored in plaintext
- Existing secrets need manual re-encryption after config
- Same volume mount pattern as audit logging and webhook