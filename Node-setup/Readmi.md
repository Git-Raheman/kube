# Ubuntu Kubernetes Prep Script

This script helps you **prepare a fresh Ubuntu server** to install a Kubernetes cluster using `kubeadm`. It installs Docker, containerd, Kubernetes tools (`kubelet`, `kubeadm`, `kubectl`), and sets system configurations required for Kubernetes.

---

## 🛠️ What This Script Does

1. **Disables swap** – required by Kubernetes.
2. **Updates system packages**.
3. **Installs CNI plugins** – needed for networking between pods.
4. **Configures sysctl and kernel modules** – required for networking and Kubernetes.
5. **Installs Docker and containerd** – container runtime for Kubernetes.
6. **Applies a custom containerd config** to use with Kubernetes.
7. **Installs Kubernetes tools** – kubelet, kubeadm, kubectl.
8. **Pulls Kubernetes images** – prefetch required images.

---

## 📜 Requirements

- Ubuntu 20.04 or 22.04 or 24 or 25 
- Root access (or sudo)
- Internet connection

---

## 🚀 Usage

```bash
chmod +x kube-node-setup.sh
sudo ./kube-node-setup.sh
