# Halo MCP Demo Helm Chart

A simple "Hello World" demo Helm chart showcasing various Kubernetes resource types for testing ArgoCD MCP server capabilities.

## Overview

This chart deploys a simple demo application with the following components:

- **Frontend**: Nginx serving a "Hello World" page
- **Backend**: Node.js API returning demo JSON responses  
- **Database**: PostgreSQL (demo configuration)
- **Redis**: Redis cache (demo configuration)
- **Worker**: Background worker (demo logs)
- **Jobs**: Migration and cleanup jobs (demo scripts)

**⚠️ This is a DEMO application with dummy configurations. Do NOT use in production!**

## Kubernetes Resources Included

This chart demonstrates a wide variety of Kubernetes resource types:

### Core Resources
- `Namespace`
- `ConfigMap`
- `Secret`
- `PersistentVolumeClaim`
- `Service` (ClusterIP, Headless)

### Workload Resources
- `Deployment` (Frontend, Backend, Redis, Worker)
- `StatefulSet` (Database)
- `Job` (Migration)
- `CronJob` (Cleanup)

### Networking
- `Ingress`
- `NetworkPolicy`

### Scaling & Availability
- `HorizontalPodAutoscaler`
- `PodDisruptionBudget`

### Security
- `ServiceAccount`
- `Role` / `ClusterRole`
- `RoleBinding` / `ClusterRoleBinding`
- `PodSecurityPolicy`

### Monitoring
- `ServiceMonitor` (Prometheus Operator)
- `PrometheusRule` (Alerting rules)

## Installation

### Prerequisites

- Kubernetes cluster (1.19+)
- Helm 3.x
- Optional: Prometheus Operator for monitoring
- Optional: Ingress controller for external access

### Install the Demo Chart

```bash
# Install from local directory
helm install halo-mcp ./halo-mcp --namespace halo-mcp --create-namespace

# Check the deployment
kubectl get all -n halo-mcp

# Access the frontend (port-forward)
kubectl port-forward -n halo-mcp svc/halo-mcp-frontend 8080:80

# Access the backend API
kubectl port-forward -n halo-mcp svc/halo-mcp-backend 3000:3000

# Upgrade
helm upgrade halo-mcp ./halo-mcp --namespace halo-mcp

# Uninstall
helm uninstall halo-mcp --namespace halo-mcp
```

## Configuration

### Key Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `frontend.enabled` | Enable frontend deployment | `true` |
| `frontend.replicaCount` | Number of frontend replicas | `3` |
| `frontend.autoscaling.enabled` | Enable HPA for frontend | `true` |
| `backend.enabled` | Enable backend deployment | `true` |
| `database.enabled` | Enable PostgreSQL database | `true` |
| `database.persistence.enabled` | Enable persistent storage | `true` |
| `redis.enabled` | Enable Redis cache | `true` |
| `worker.enabled` | Enable worker deployment | `true` |
| `monitoring.enabled` | Enable monitoring resources | `true` |
| `security.rbac.enabled` | Enable RBAC resources | `true` |
| `security.networkPolicy.enabled` | Enable network policies | `true` |
| `ingress.enabled` | Enable ingress | `true` |

### Example Custom Values

```yaml
# custom-values.yaml
app:
  name: my-halo-mcp
  environment: staging

frontend:
  replicaCount: 2
  autoscaling:
    minReplicas: 1
    maxReplicas: 5

database:
  persistence:
    size: 20Gi
    storageClass: fast-ssd

ingress:
  hosts:
    - host: my-app.example.com
      paths:
        - path: /
          pathType: Prefix

monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
```

## Testing ArgoCD MCP Server

This chart is specifically designed to test various ArgoCD MCP server capabilities:

### Resource Actions Available

Different resource types support different actions:

- **Deployments**: restart, scale, pause, resume
- **Pods**: restart, delete, logs
- **StatefulSets**: restart, scale
- **Jobs**: delete, suspend (for CronJobs)
- **Services**: delete
- **ConfigMaps/Secrets**: delete

### Testing Scenarios

1. **Application Management**
   ```bash
   # List applications
   # Get application details
   # Sync application
   ```

2. **Resource Operations**
   ```bash
   # Scale frontend deployment
   kubectl scale deployment/my-halo-mcp-frontend --replicas=5
   
   # Restart backend deployment
   kubectl rollout restart deployment/my-halo-mcp-backend
   
   # View logs
   kubectl logs -l app.kubernetes.io/component=backend
   ```

3. **Monitoring & Events**
   ```bash
   # Check events
   kubectl get events --sort-by='.lastTimestamp'
   
   # View resource tree
   # Get application events
   ```

## Troubleshooting

### Common Issues

1. **Database Connection Issues**
   ```bash
   # Check database pod status
   kubectl get pods -l app.kubernetes.io/component=database
   
   # Check database logs
   kubectl logs -l app.kubernetes.io/component=database
   
   # Verify service name (should match your release name)
   kubectl get svc | grep database
   ```

2. **Service Name Issues**
   The database service name depends on your Helm release name:
   - Release name `halo-mcp` → Service: `halo-mcp-database`
   - Release name `my-app` → Service: `my-app-halo-mcp-database`
   
   If you see connection errors, check the actual service name:
   ```bash
   kubectl get svc -l app.kubernetes.io/component=database
   ```

3. **Frontend Permission Issues**
   If nginx fails to start, check the logs:
   ```bash
   kubectl logs -l app.kubernetes.io/component=frontend -c frontend
   ```

### Useful Commands

```bash
# Get all resources
kubectl get all -l app.kubernetes.io/instance=my-halo-mcp

# Check resource usage
kubectl top pods -l app.kubernetes.io/instance=my-halo-mcp

# Port forward to access services locally
kubectl port-forward svc/my-halo-mcp-frontend 8080:80
kubectl port-forward svc/my-halo-mcp-backend 3000:3000

# Execute into database
kubectl exec -it my-halo-mcp-database-0 -- psql -U halo_user -d halo_mcp
```

## Contributing

This is a demo chart for testing purposes. Feel free to modify and extend it for your testing needs.

## License

This chart is provided as-is for demonstration purposes.# mcp-test-chart
