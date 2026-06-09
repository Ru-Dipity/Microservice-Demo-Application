# Sock Shop

A minimal microservices demo for running the Sock Shop application on Kubernetes.

## Overview

This folder contains Kubernetes manifests and resources for deploying the Sock Shop sample application. The README provides a quick way to get the application running on a Kubernetes cluster for testing and demonstrations.

## Requirements

- A Kubernetes cluster (kind, minikube, or cloud provider)
- `kubectl` configured to access the cluster

## Quick Start

1. Clone the repository and change to this directory:

```bash
git clone <your-repo-url>
cd Sock_Shop
```

2. Apply the dev namespace and dev deployment manifests:

```bash
kubectl apply -f Kubernetes/namespace-dev.yaml -f Kubernetes/deployment-dev.yaml
```

3. Check pods and services in the dev namespace:

```bash
kubectl get pods -n sock-shop-dev
kubectl get svc -n sock-shop-dev
```

## Notes

- Use `Kubernetes/namespace-dev.yaml` and `Kubernetes/deployment-dev.yaml` for the development environment.
- Use `Kubernetes/namespace-prod.yaml` and `Kubernetes/deployment-prod.yaml` for the production environment.
- For production-like setups, review additional manifests under `Kubernetes/` and the `Monitoring/` folder for observability components.

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

5. Grafana notes:

- Default credentials are often `admin`/`admin`; verify the manifest or secret for the configured password.
- Add a Prometheus data source in Grafana pointing to `http://localhost:9090` (or the internal service URL when Grafana runs inside the cluster).
- Import dashboards from the Grafana dashboard directory or use official Sock Shop / Prometheus dashboards.

Alternative access methods

- Port-forward directly to a Grafana pod (for example if the pod exposes 3000):

```bash
# find the pod name
kubectl -n monitoring get pods -l app=grafana

# port-forward to the pod's port 3000
kubectl -n monitoring port-forward pod/<grafana-pod-name> 3000:3000
```

- If the service is a NodePort (configured in `22-grafana-svc.yaml`), access Grafana using the node's IP and the nodePort (example `31300`):

```bash
# Replace <node-ip> with your cluster node address
http://<node-ip>:31300
```

If you prefer not to port-forward, install a LoadBalancer/Ingress for the services and secure access appropriately.

Discovered ports & default credentials

- Prometheus NodePort: `31090` (service port `9090` -> nodePort `31090`).
- Grafana NodePort: `31300` (service port `80` -> nodePort `31300`, container `3000`).
- Grafana default credentials (from `21-grafana-dep.yaml`): **admin / admin**. Change these in production.

## Contact

For questions or contributions, open an issue in the repository.
