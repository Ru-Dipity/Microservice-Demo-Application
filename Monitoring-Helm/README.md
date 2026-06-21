# Monitoring with Helm Charts

This directory contains a Helm-based monitoring setup built on the Prometheus Community
`kube-prometheus-stack` chart.

## Components

The chart deploys the following monitoring components:

- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- Kube State Metrics
- Prometheus Operator

## Quick Start

### 1. Add the Helm repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 2. Deploy `kube-prometheus-stack`

```bash
# Create the namespace if it does not already exist.
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Install or upgrade the monitoring stack with the local values file.
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f values.yaml \
  --version 61.3.1
```

### 3. Verify the deployment

```bash
# Check pod status.
kubectl get pods -n monitoring

# Check services.
kubectl get svc -n monitoring
```

## Access Prometheus and Grafana

### Option 1: Port Forwarding

Use port forwarding when you want local-only access from your workstation.

```bash
# Prometheus
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090

# Grafana
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

Access URLs:

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000

### Option 2: Protected Remote Access

The current `values.yaml` keeps both services internal as `ClusterIP`.

If you need remote access, prefer one of these protected options:

- VPN into the cluster network
- SSH tunnel to a trusted host
- Authenticated Ingress or reverse proxy with TLS and access restrictions

## Grafana Login

- Username: `admin`
- Password: `prom-operator`

You can change the admin password in `values.yaml`.

## Configuration Notes

Key settings in `values.yaml`:

- `prometheus.service.type`: Service type for Prometheus
- `grafana.service.type`: Service type for Grafana
- `grafana.adminPassword`: Grafana admin password
- `alertmanager.enabled`: Enables or disables Alertmanager
- `prometheus-node-exporter.hostNetwork`: Disabled to avoid host port conflicts on a single-node cluster
- `prometheus-node-exporter.hostPID`: Disabled to match the non-host-network setup

## Traefik Metrics

If you want Prometheus to scrape Traefik metrics, make sure the Traefik Service is annotated like this:

```yaml
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "9100"
  prometheus.io/path: "/metrics"
```

## Upgrade

```bash
helm repo update
helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f values.yaml \
  --version 61.3.1
```

## Uninstall

```bash
helm uninstall kube-prometheus-stack -n monitoring
kubectl delete namespace monitoring
```

If CRDs remain after uninstall, remove them only if you are sure they are no longer needed by any other Prometheus Operator installation.
