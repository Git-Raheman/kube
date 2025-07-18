Kubernetes Cluster Setup with kubeadm and Flannel
## 1️⃣ Initialize the Control Plane

#Flannel requires a specific Pod network CIDR. Run:

---

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
````

✅ This will set up the control plane and output a `kubeadm join` command for adding worker nodes. **Save that command!**

---

## 2️⃣ Configure kubectl for Your User

By default, the admin config is owned by root. To let your normal user use `kubectl`:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

## 3️⃣ Install Flannel CNI

Apply the Flannel network add-on:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

✅ This deploys Flannel across your cluster and enables Pod networking.

---
