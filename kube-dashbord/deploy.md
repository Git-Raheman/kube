## 🚀 Deploy Kubernetes Dashboard

### ✅ 1. **Apply the Dashboard YAML**

Run this in your terminal:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

> This will deploy the Kubernetes Dashboard in the `kubernetes-dashboard` namespace.

---

### ✅ 2. **Create a Service Account for Access**

Create a YAML file called `admin-user.yaml`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

Apply it:

```bash
kubectl apply -f admin-user.yaml
```

---

### ✅ 3. **Get the Login Token**

Run this command:

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

> Copy the token — you'll use it to log in.

---
### ✅ Done!
