#!/bin/bash

set -e

SA_NAME="kube-admin"
NAMESPACE="kube-system"
CONFIG_PATH="/root/kube-admin-config.yaml"
NODE_PORT=30200

echo "[1/5] Creating ServiceAccount and ClusterRoleBinding..."

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $SA_NAME
  namespace: $NAMESPACE
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${SA_NAME}-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: $SA_NAME
  namespace: $NAMESPACE
---
apiVersion: v1
kind: Secret
metadata:
  name: ${SA_NAME}-token
  namespace: $NAMESPACE
  annotations:
    kubernetes.io/service-account.name: $SA_NAME
type: kubernetes.io/service-account-token
EOF

echo "[2/5] Waiting for token to be created..."
sleep 5

echo "[3/5] Fetching token..."
TOKEN=$(kubectl -n $NAMESPACE get secret ${SA_NAME}-token -o jsonpath='{.data.token}' | base64 --decode)

if [ -z "$TOKEN" ]; then
  echo "❌ Failed to retrieve token. Aborting."
  exit 1
fi

echo "[4/5] Detecting Node IP..."
NODE_IP=$(hostname -I | awk '{print $1}')
echo "Detected Node IP: $NODE_IP"

echo "[5/5] Generating kubeconfig at $CONFIG_PATH..."

cat <<EOF > $CONFIG_PATH
apiVersion: v1
kind: Config
clusters:
- name: kubernetes
  cluster:
    server: http://$NODE_IP:$NODE_PORT
    insecure-skip-tls-verify: true
contexts:
- name: ${SA_NAME}-context
  context:
    cluster: kubernetes
    user: $SA_NAME
current-context: ${SA_NAME}-context
users:
- name: $SA_NAME
  user:
    token: $TOKEN
EOF

echo "✅ kubeconfig created at $CONFIG_PATH"
