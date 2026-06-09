# Sock Shop

A minimal microservices demo for running the Sock Shop application on Kubernetes.

## Overview

This folder contains Kubernetes manifests and resources for deploying the Sock Shop sample application. The documentation explains how to deploy locally and how to use the GitHub Actions CI/CD pipeline.

## Requirements

- A Kubernetes cluster (kind, minikube, k3s, or a cloud provider)
- `kubectl` configured to access the target cluster
- For GitHub Actions deployment: a reachable Kubernetes API server and valid kubeconfig data stored as GitHub Secrets

## Local Deployment

1. Clone the repository and change to this directory:

```bash
git clone <your-repo-url>
cd Sock_Shop
```

2. Deploy the development environment:

```bash
kubectl apply -f Kubernetes/namespace-dev.yaml -f Kubernetes/deployment-dev.yaml
```

3. Deploy the production environment:

```bash
kubectl apply -f Kubernetes/namespace-prod.yaml -f Kubernetes/deployment-prod.yaml
```

4. Verify the deployment:

```bash
kubectl get pods -n sock-shop-dev
kubectl get svc -n sock-shop-dev
kubectl get pods -n sock-shop-prod
kubectl get svc -n sock-shop-prod
```

## GitHub Actions CI/CD

This repository includes a workflow at `.github/workflows/ci-cd.yaml` with the following behavior:

- `Test` job runs on pushes or pull requests to `main` and `develop` and validates YAML syntax.
- `deploy-dev` job runs only on the `develop` branch.
- `deploy-prod` job runs only on the `main` branch.

### Branch usage

- `develop`: deploys `Kubernetes/namespace-dev.yaml` and `Kubernetes/deployment-dev.yaml` using `KUBE_CONFIG_DATA_DEV`.
- `main`: deploys `Kubernetes/namespace-prod.yaml` and `Kubernetes/deployment-prod.yaml` using `KUBE_CONFIG_DATA_PROD`.

### Required GitHub Secrets

Configure the following repository secrets in GitHub Settings > Secrets:

- `KUBE_CONFIG_DATA_DEV`
- `KUBE_CONFIG_DATA_PROD`

Each secret must contain the Base64-encoded contents of a kubeconfig file that can access the target Kubernetes cluster.

### Generate the Base64 kubeconfig value

If your kubeconfig file is available locally, run:

```bash
cat /etc/rancher/k3s/k3s.yaml | base64 -w0
```

If `base64` does not support `-w0`, use:

```bash
cat /etc/rancher/k3s/k3s.yaml | base64 | tr -d '\n'
```

Then paste the resulting single-line string into the appropriate GitHub Secret.

### Important note for GitHub-hosted runners

If you use GitHub-hosted runners, the kubeconfig must point to a Kubernetes API server reachable from the runner.

Do not use a kubeconfig whose `server:` field is `https://127.0.0.1:6443` or `https://localhost:6443` unless the runner is self-hosted on the same machine as the cluster.

If your cluster is local and not reachable from GitHub-hosted runners, use a self-hosted runner in the same network or expose the API server over a reachable address.

## Troubleshooting

### `error validating ... failed to download openapi: Get "http://localhost:8080/openapi/v2"`

This indicates the kubeconfig is pointing at a local API server address that the GitHub runner cannot access. Check the kubeconfig's `server:` value and make sure it is reachable from the runner.

### Dev deploy not triggering

The `deploy-dev` job only runs on the `develop` branch. Push to `develop` to trigger Dev deployment.

### Prod deploy not triggering

The `deploy-prod` job only runs on the `main` branch.

## Monitoring (Prometheus & Grafana)

This repository includes monitoring manifests under the `Monitoring/` directory for deploying Prometheus and Grafana.

Quick steps to deploy and access monitoring:

1. Apply the monitoring manifests:

```bash
kubectl apply -f Monitoring/
```

2. Verify monitoring pods and services are running:

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

3. Port-forward services to access the UIs locally:

```bash
# Prometheus UI
kubectl -n monitoring port-forward svc/prometheus 9090:9090

# Grafana UI
kubectl -n monitoring port-forward svc/grafana 3000:80
```

4. Open the UIs in your browser:

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000

## Contact

For questions or contributions, open an issue in the repository.
