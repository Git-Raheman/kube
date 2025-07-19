# NFS Subdir External Provisioner (Production Setup)

This repository sets up a production-ready dynamic volume provisioner using NFS in a Kubernetes cluster using **Helm**.

---

## 📦 What is this?

The [nfs-subdir-external-provisioner] allows Kubernetes to dynamically provision PersistentVolumeClaims (PVCs) on a **shared NFS server**, by creating sub-directories for each PVC.

---

## ⚙️ Cluster Prerequisites

- A running **NFS server** (e.g., on IP `192.168.21.1`)
- Shared folder exported on the NFS server (e.g., `/kube-nfs`)
- Kubernetes cluster set up using `kubeadm` (1 master + 4 nodes)
- Helm installed on your machine

---

## 🚀 Setup Instructions

### 1. Create a Namespace
```bash
kubectl create namespace nfs-storage

### 2. Add Helm Repo
```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo update
---

### 3. Install the NFS Provisioner with Helm
```bash
helm install nfs-client nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --namespace nfs-storage \
  --set nfs.server=192.168.21.1 \
  --set nfs.path=/kube-nfs \
  --set storageClass.name=nfs-client \
  --set storageClass.defaultClass=true \
  --set storageClass.reclaimPolicy=Retain \
  --set nodeSelector."kubernetes\.io/os"=linux \
  --set tolerations[0].key="node-role.kubernetes.io/master" \
  --set tolerations[0].effect="NoSchedule"
---

### ✅ Verifying the Setup
```bash
kubectl get pods -n nfs-storage
kubectl get storageclass
---

### 🧪 Test with a PVC
# Create a file pvc.yaml:
```bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: nfs-client
  resources:
    requests:
      storage: 1Gi
---

### Apply it:
```bash
kubectl apply -f pvc.yaml

