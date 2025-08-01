# 🛡️ Kubernetes Kubeconfig Auto-Generator

This script automatically creates a `kube-admin` ServiceAccount with full `cluster-admin` privileges, generates a non-expiring token, and builds a ready-to-use `kubeconfig` file for accessing the Kubernetes Dashboard.

---

## 🚀 Features

- Creates a `kube-admin` service account in the `kube-system` namespace
- Binds it to the `cluster-admin` role
- Generates a non-expiring token
- Detects the current node's IP address automatically
- Creates a kubeconfig file at `/root/kube-admin-config.yaml`
- Configured to work with Kubernetes Dashboard on HTTP port `30200`

---

## 📂 Files

- `create_kubeconfig.sh` – Main setup script


---

## 🧾 Requirements

- Kubernetes cluster running (v1.24+)
- `kubectl` access as a cluster-admin
- Kubernetes Dashboard already installed and exposed via NodePort `30200`

---

## 🛠️ Usage

```bash
chmod +x create_kubeconfig.sh
sudo ./create_kubeconfig.sh
