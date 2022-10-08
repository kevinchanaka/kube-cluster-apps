#!/bin/bash

export $(grep -v '^#' .env | xargs)

namespaces=(
    "argocd"
    "cert-manager"
    "democratic-csi" 
    "ingress-nginx" 
    "metallb-system"
    "monitoring"
    "scaling"
)

# Creating namespaces used by cluster
for ns in ${namespaces[@]}; do
  kubectl create namespace $ns
done

# Creating secrets
kubectl create secret generic sagemcom-router-reboot \
    --from-literal=ROUTER_USERNAME=${ROUTER_USERNAME} \
    --from-literal=ROUTER_PASSWORD=${ROUTER_PASSWORD}

envsubst < democratic-csi.yaml > driver-config-file.yaml

kubectl create secret generic zfs-iscsi-democratic-csi-driver-config \
    -n democratic-csi --from-file=driver-config-file.yaml

rm driver-config-file.yaml

envsubst < terraria-config.yaml | kubectl apply -f -
