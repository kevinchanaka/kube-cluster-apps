# kube-cluster-apps

Repository of resources deployed to Kubernetes via argocd

## Usage

1. Deploy secrets by running bash script

```bash
cd secrets && ./create-secrets.sh
```

2. Install ArgoCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install -n argocd argocd argo/argo-cd
```

3. Deploy `kube-prometheus-stack` [CRDs](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#upgrading-an-existing-release-to-a-new-major-version)

4. Create secret called `etcd-client` in `monitoring` namespace (for Prometheus to monitor etcd) by running the commands below within master node (more information [here](https://github.com/helm/charts/issues/6921#issuecomment-480873676))

```bash
D="$(mktemp -d)"
cp /etc/kubernetes/pki/etcd/{ca.crt,healthcheck-client.{crt,key}} $D
kubectl --kubeconfig /etc/kubernetes/admin.conf -n monitoring create secret generic etcd-client --from-file="$D"
rm -fr "$D"
```

5. Create ArgoCD application object, and sync app from UI

```bash
kubectl apply -f applications.yaml
```
