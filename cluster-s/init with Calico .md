initialize your Kubernetes cluster using `kubeadm` with **Calico** as the CNI (Container Network Interface), :

### ✅: Initialize Kubernetes Control Plane (on master node)

Choose a pod network CIDR compatible with Calico. Calico uses `192.168.0.0/16` by default.

```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

✅ After it initializes, you'll get a `kubeadm join` command. **Save it!**

Then set up your `kubectl` config:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

### ✅ Step 3: Install Calico Network Plugin (on master node)

Apply the Calico manifest:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
```


