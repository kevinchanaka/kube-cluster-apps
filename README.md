# kube-cluster-apps

Repository of resources deployed to Kubernetes via argocd

## Usage

1. Deploy secrets by running bash script. This script can be re-run to add new secrets

```bash
cd secrets && ./create-secrets.sh
```

2. Install ArgoCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install -n argocd argocd argo/argo-cd
```

3. Create secret called `etcd-client` in `monitoring` namespace (for Prometheus to monitor etcd) by running the commands below within master node (more information [here](https://github.com/helm/charts/issues/6921#issuecomment-480873676))

```bash
D="$(mktemp -d)"
cp /etc/kubernetes/pki/etcd/{ca.crt,healthcheck-client.{crt,key}} $D
kubectl --kubeconfig /etc/kubernetes/admin.conf -n monitoring create secret generic etcd-client --from-file="$D"
rm -fr "$D"
```

4. Create ArgoCD application object, and sync app from UI

```bash
kubectl apply -f applications.yaml
```

## Upgrade

1. Upgrade ArgoCD if required. Check [here](https://github.com/argoproj/argo-helm/pkgs/container/argo-helm%2Fargo-cd) for available ArgoCD releases

```bash
helm repo update
helm upgrade -n argocd argocd argo/argo-cd
```

2. Review releases links on relevant helm charts and update target revisions
