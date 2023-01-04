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

3. Login to ArgoCD UI and connect GitHub repository via SSH (requires GitHub SSH keys)

4. Create ArgoCD application object, and sync app from UI

```bash
kubectl apply -f applications.yaml
```
