---
bash
kubectl -n kubernetes-dashboard patch svc kubernetes-dashboard -p '{"spec": {"type": "NodePort", "ports": [{"port": 443, "targetPort": 8443, "nodePort": 30200}]}}'
---
