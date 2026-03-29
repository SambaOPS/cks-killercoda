# Network Policy

## 🧩 Problem Statement

<details>
<summary>Click to expand the problem statement</summary>

You are working in a Kubernetes cluster where multiple namespaces host different application components.
To improve security, inter-namespace network communication must be controlled using **NetworkPolicies**.

---

### ✅ Requirements

1. In the **`production`** namespace, create a NetworkPolicy named **`deny-policy`** that **blocks all incoming traffic** to Pods by default.

   The `production` namespace has the label:

   ```
   env: production
   ```

2. In the **`database`** namespace, create a NetworkPolicy named **`allow-from-production`** that **permits ingress traffic only from Pods running in the production namespace**.

   * Use the **namespace label** to allow traffic.
   * The `database` namespace has the label:

     ```
     env: database
     ```

---

### 📌 Note

* Do **not** modify any Deployments.

</details>

---

## ✅ Solution

<details>
<summary>Click to expand the solution</summary>

You may refer to the Kubernetes NetworkPolicy documentation if needed.

---

### 1) deny-policy (block all ingress in production)

This policy selects **all Pods** in the `production` namespace and blocks ingress by default.

```
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-policy
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF
```

---

### 2) allow-from-production (allow ingress only from production namespace)

This policy selects **all Pods** in the `database` namespace and allows ingress only from namespaces labeled `env=production`.

```
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-production
  namespace: database
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          env: production
EOF
```

</details>

---

## 🧪 Optional Validation

<details>
<summary>Click to expand validation steps</summary>

Create test Pods:

```
kubectl run prod-pod --image=nginx -n production
kubectl run db-pod --image=nginx -n database
kubectl run default-pod --image=busybox -n default -- sleep 3600
```

Get the DB Pod IP:

```
DB_IP=$(kubectl get pod db-pod -n database -o jsonpath='{.status.podIP}')
echo $DB_IP
```

Test access from production (should be allowed):

```
kubectl exec -n production prod-pod -- curl -m 5 http://$DB_IP
```

Test access from default namespace (should be blocked):

```
kubectl exec -n default default-pod -- wget -T 5 -qO- http://$DB_IP
```

Cleanup:

```
kubectl delete pod prod-pod -n production
kubectl delete pod db-pod -n database
kubectl delete pod default-pod -n default
```

</details>

---

## 🛠 Setup Practice Scenario

<details>
<summary>Click to expand setup steps</summary>

Ensure your cluster has a CNI that supports NetworkPolicies (for example, Calico).

---

### Step 1: Create namespaces + labels

```
kubectl create namespace production
kubectl label namespace production env=production
```

```
kubectl create namespace database
kubectl label namespace database env=database
```

---

### Step 2: Install Calico (if needed)

```
curl -L https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml -o calico.yaml
kubectl apply -f calico.yaml
```

</details>

---
