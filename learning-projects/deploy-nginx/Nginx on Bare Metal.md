---
## **🔥 Full HA Setup for Nginx on Bare Metal K8s**
### **1. Prerequisites**
✅ **Kubernetes Cluster:**  
- 1 Master (`192.168.21.50`)  
- 2 Nodes (`192.168.21.51`, `192.168.21.52`)  

✅ **Storage:** NFS (already set up for `/nfs/data` and `/nfs/log`)  

✅ **Networking:**  
- All nodes must be in the same L2 network (same subnet).  
- A **free IP** for the Load Balancer (e.g., `192.168.21.100`).  

---

## **2. Install MetalLB (Load Balancer)**
MetalLB assigns an external IP to `LoadBalancer` services.

### **Install MetalLB**
```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml
```

### **Configure IP Pool**
Create `metallb-config.yaml`:
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: nginx-ip-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.21.100/32  # VIP for Nginx
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: nginx-l2-advert
  namespace: metallb-system
spec:
  ipAddressPools:
  - nginx-ip-pool
```
Apply:
```bash
kubectl apply -f metallb-config.yaml
```

---

## **3. Update Nginx Service to `LoadBalancer`**
Modify your `nginx-service`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: nginx
spec:
  type: LoadBalancer  # Changed from NodePort
  externalTrafficPolicy: Local  # Preserves client IP
  ports:
    - port: 80
      targetPort: 80
  selector:
    app: nginx
```
Apply:
```bash
kubectl apply -f nginx-deployment.yml
```

### **Verify MetalLB IP Assignment**
```bash
kubectl get svc -n nginx
```
Output:
```
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
nginx-service   LoadBalancer   10.96.xx.xx    192.168.21.100   80:30500/TCP
```
Now, users access Nginx via **`http://192.168.21.100`** (not node IPs).  

---

## **4. Add Keepalived (Optional but Recommended)**
If MetalLB’s L2 mode isn’t enough (e.g., for multi-subnet HA), use **Keepalived** for VIP failover.

### **Install Keepalived on All Nodes**
```bash
sudo apt install keepalived -y  # Ubuntu/Debian
sudo yum install keepalived -y  # CentOS/RHEL
```

### **Configure Keepalived (`/etc/keepalived/keepalived.conf`)**
On **Node 1 (`192.168.21.51`)**:
```conf
vrrp_instance VI_1 {
    state MASTER
    interface eth0  # Your network interface
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass yourpassword
    }
    virtual_ipaddress {
        192.168.21.100/24  # Same as MetalLB IP
    }
}
```

On **Node 2 (`192.168.21.52`)** (Backup):
```conf
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 51
    priority 50
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass yourpassword
    }
    virtual_ipaddress {
        192.168.21.100/24
    }
}
```

### **Start Keepalived**
```bash
sudo systemctl enable --now keepalived
```

Now, if **Node 1 dies**, Node 2 takes over the VIP (`192.168.21.100`).  

---

## **5. Test Failover**
### **Simulate Node Failure**
1. **Shut down Node 1 (`192.168.21.51`)**  
2. **Check if VIP moves to Node 2:**
   ```bash
   ip addr show eth0 | grep "192.168.21.100"
   ```
3. **Access Nginx via `192.168.21.100`** – it should still work!  

---

## **✅ Final HA Architecture**
| Component          | Role                          |
|--------------------|-------------------------------|
| **MetalLB**        | Assigns `192.168.21.100` to Nginx |
| **Keepalived**     | Ensures VIP failover          |
| **Nginx (2 pods)** | Runs on both nodes            |
| **K8s Service**    | `LoadBalancer` type           |

Now:
- Users **always** access `http://192.168.21.100` (no hardcoded node IPs).  
- If **any node dies**, traffic **automatically fails over**.  
- **Client IPs** are preserved in logs.  
