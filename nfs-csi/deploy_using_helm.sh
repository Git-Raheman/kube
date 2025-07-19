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
