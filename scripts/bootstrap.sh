#!/bin/bash
# This script bootstraps a new cluster

# ArgoCD initial login password
# kubectl get secret -n argocd argocd-initial-admin-secret -o=jsonpath={.data.password} | base64 --decode

# ArgoCD initial port forward
# kubectl port-forward -n argocd service/argocd-server 8080:443

set -euo pipefail

echo "Adding helm repos"
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add flannel https://flannel-io.github.io/flannel/

echo "Templating manifests for flannel"
helm template flannel -f values/flannel.yaml --namespace kube-system flannel/flannel | kubectl apply --server-side -f -
sleep 10

echo "Templating manifests for ArgoCD"
kubectl create namespace argocd || true
helm template argocd oci://ghcr.io/argoproj/argo-helm/argo-cd --create-namespace --namespace argocd | kubectl apply --server-side -f -
sleep 10

echo "Deploying root app-of-apps"
kubectl apply -f root.yaml

echo "Bootstrap complete"
