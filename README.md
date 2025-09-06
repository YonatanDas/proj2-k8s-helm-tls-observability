# Kubernetes Helm TLS & Observability Project

[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=flat&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat&logo=Helm&labelColor=0F1689)](https://helm.sh/)

A production-ready Kubernetes deployment template featuring:
- 🔒 **TLS/SSL Certificate Management** with cert-manager
- 📊 **Observability Stack** with Prometheus and Grafana
- 🚀 **Multi-environment** support (dev/prod)
- 🔄 **GitOps-ready** structure
- 🛡️ **Security Best Practices**

This project uses [Podinfo](https://github.com/stefanprodan/podinfo) as a sample application to demonstrate these concepts.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Components](#components)
- [Accessing Services](#accessing-services)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- Kubernetes cluster (v1.20+)
- `kubectl` (v1.20+)
- Helm (v3.0+)
- `cert-manager` (v1.10.0+)
- Ingress controller (e.g., nginx, traefik)

## Project Structure

```
.
├── charts/                    # Helm charts directory
│   └── myapp/                # Main application chart
│       ├── templates/        # Kubernetes manifest templates
│       │   ├── deployment.yaml  # Application deployment
│       │   ├── service.yaml     # Service definition
│       │   ├── hpa.yaml        # Horizontal Pod Autoscaler
│       │   └── ingress.yaml    # Ingress configuration
│       ├── Chart.yaml        # Chart metadata
│       └── values.yaml       # Default configuration values
│
├── infrastructure/          
│   ├── cert-manager/         # Certificate management
│   │   ├── app-certificate.yaml
│   │   ├── app-ingress.yaml
│   │   ├── app-namespace.yaml
│   │   └── selfsigned-issuer.yaml
│   │
│   └── monitoring/           # Monitoring stack
│       ├── grafana-certificate.yaml
│       ├── kube-prometheus-stack-values.yaml
│       ├── podinfo-dashboard.json
│       └── podinfo-servicemonitor.yaml
│
├── environments/             # Environment-specific configurations
│   ├── dev/                
│   │   └── values.yaml      # Dev overrides
│   └── prod/             
│       └── values.yaml      # Prod overrides
│
├── docs/                     # Documentation
│   ├── demo-script.md
│   └── troubleshooting.md
└── README.md                # This file
```

## Quick Start

### 1. Install cert-manager
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml
```

### 2. Deploy Infrastructure
```bash
# Deploy certificates and issuers
kubectl apply -f infrastructure/cert-manager/

# Deploy monitoring stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f infrastructure/monitoring/kube-prometheus-stack-values.yaml
```

### 3. Deploy Application
#### For development:
```bash
helm upgrade --install myapp ./charts/myapp -f environments/dev/values.yaml
```

#### For production:
```bash
helm upgrade --install myapp ./charts/myapp -f environments/prod/values.yaml
```

## Accessing the Application

### Podinfo Web Interface
```bash
kubectl port-forward svc/myapp 9898:9898
```
Then open http://localhost:9898 in your browser.

### Grafana Dashboard
```bash
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80
```
- URL: http://localhost:3000
- Username: admin
- Password: prom-operator (default, change in production)

## Components

### 1. Application (Podinfo)
- **Purpose**: Sample microservice that showcases best practices for running cloud-native applications
- **Features**:
  - Metrics endpoints
  - Health checks
  - Graceful shutdown
  - Configuration management

### 2. Cert-Manager
- **Purpose**: Automates the management and issuance of TLS certificates
- **Components**:
  - Self-signed issuer (for development)
  - Certificate resources for applications
  - Automatic certificate renewal

### 3. Monitoring Stack (kube-prometheus-stack)
- **Components**:
  - Prometheus: Metrics collection and storage
  - Grafana: Visualization and dashboards
  - AlertManager: Alerting
  - ServiceMonitors: Automatic discovery of services to monitor

## Cleanup

To remove all resources:

```bash
# Uninstall the application
helm uninstall myapp

# Uninstall monitoring
helm uninstall kube-prometheus-stack

# Remove cert-manager
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml

# Remove namespaces (if they exist)
kubectl delete namespace monitoring
kubectl delete namespace cert-manager
```

## Prerequisites

1. Kubernetes cluster (minikube, EKS, AKS, GKE, etc.)
2. `kubectl` configured to communicate with your cluster
3. Helm 3.x
4. `cert-manager` installed in the cluster
```

## Accessing the Application

### Podinfo Web Interface
```bash
kubectl port-forward svc/myapp 9898:9898
```
Then open http://localhost:9898 in your browser.

### Grafana Dashboard
```bash
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80
```
- URL: http://localhost:3000
- Username: admin
- Password: prom-operator (default, change in production)

### Prometheus
```bash
kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090
```
Then open http://localhost:9090 in your browser.

## Customization

### Environment-Specific Configuration
- Development: `chart/values-dev.yaml`
- Production: `chart/values-prod.yaml`

### Certificate Configuration
- Update `k8s-addons/cert-manager/` files for production certificates
- Modify `k8s-addons/podinfo-certificate.yaml` for custom domains

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for common issues and solutions.

## Cleanup

To remove all resources:

```bash
helm uninstall podinfo
helm uninstall kube-prometheus-stack
kubectl delete -f k8s-addons/cert-manager/
```
