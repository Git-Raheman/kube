Install MetalLB (Load Balancer)
MetalLB assigns an external IP to LoadBalancer services.

Install MetalLB
bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml
Configure IP Pool
Create metallb-config.yaml:

yaml
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
Apply:

bash
kubectl apply -f metallb-config.yaml
3. Update Nginx Service to LoadBalancer
Modify your nginx-service:

yaml
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
Apply:

bash
kubectl apply -f nginx-deployment.yml
Verify MetalLB IP Assignment
bash
kubectl get svc -n nginx
Output:

text
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
nginx-service   LoadBalancer   10.96.xx.xx    192.168.21.100   80:30500/TCP
Now, users access Nginx via http://192.168.21.100 (not node IPs).
