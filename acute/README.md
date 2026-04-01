# Acute Helm Chart

A flexible and comprehensive Helm chart for deploying applications on Kubernetes. This chart supports multiple workload types including Deployments, StatefulSets, Jobs, and CronJobs, with extensive configuration options for production-ready deployments.

## Description

This Helm chart provides a standardized way to deploy containerized applications to Kubernetes with support for:

- **Multiple workload types**: Deployment, StatefulSet, Job, and CronJob
- **Auto-scaling**: Horizontal Pod Autoscaler (HPA) and KEDA ScaledObject
- **Modern stable Kubernetes features**: K8s 1.33 sidecar containers and K8s 1.35 in-place resize policy
- **Networking**: Service, Ingress, and NetworkPolicy
- **Configuration management**: ConfigMap and Secret support
- **High availability**: PodDisruptionBudget and health probes
- **Security**: ServiceAccount, security contexts, and network policies

## Prerequisites

- Kubernetes 1.33+
- Helm 4.x (this chart is Helm v4-only)
- kubectl configured to access your Kubernetes cluster

## Installation

### Add the Helm repository

```bash
helm repo add novacaap https://novacaap.github.io/helm-chart
helm repo update
```

### Install the chart

```bash
helm install acute novacaap/acute
```

### Install with custom values

```bash
helm install my-app novacaap/acute -f my-values.yaml
```

## Configuration

The following table lists the configurable parameters and their default values:

### General Parameters

| Parameter          | Description                                             | Default      |
| ------------------ | ------------------------------------------------------- | ------------ |
| `nameOverride`     | Override the name of the chart                          | `""`         |
| `fullnameOverride` | Override the full name of the chart                     | `""`         |
| `kind`             | Workload type: Deployment, StatefulSet, Job, or CronJob | `Deployment` |
| `replicaCount`     | Number of replicas                                      | `1`          |

### Image Configuration

| Parameter                       | Description                | Default                |
| ------------------------------- | -------------------------- | ---------------------- |
| `containers[].image.repository` | Container image repository | `nginx`                |
| `containers[].image.tag`        | Container image tag        | `""` (uses appVersion) |
| `containers[].image.pullPolicy` | Image pull policy          | `IfNotPresent`         |
| `imagePullSecrets`              | Image pull secrets         | `[]`                   |

### Workload-Specific Configuration

#### Deployment

- `updateStrategy`: Update strategy configuration
- `minReadySeconds`: Minimum ready time before a pod is considered available
- `revisionHistoryLimit`: Number of old ReplicaSets to retain
- `progressDeadlineSeconds`: Deployment progress deadline
- `paused`: Pause rollout processing

#### StatefulSet

- `updateStrategy`: Update strategy configuration
- `podManagementPolicy`: Pod management policy (OrderedReady/Parallel)
- `revisionHistoryLimit`: Number of old ControllerRevisions to retain
- `ordinalsStart`: Start ordinal for pod numbering
- `persistence.claimRetentionPolicy`: PVC retention policy when deleted or scaled down

#### CronJob/Job

- `schedule`: Cron schedule expression (CronJob only)
- `restartPolicy`: Pod restart policy
- `backoffLimit`: Number of retries before marking Job as failed
- `parallelism`: Number of pods to run in parallel
- `completions`: Total successful pod completions required
- `completionMode`: Completion mode (`NonIndexed`/`Indexed`)
- `activeDeadlineSeconds`: Deadline for job execution
- `ttlSecondsAfterFinished`: TTL for finished Jobs
- `podFailurePolicy`: Rules for handling pod failures
- `startingDeadlineSeconds`: Deadline for starting missed runs (CronJob only)
- `successfulJobsHistoryLimit`: Number of successful job history to retain
- `failedJobsHistoryLimit`: Number of failed job history to retain
- `concurrencyPolicy`: Concurrency policy (Allow/Forbid/Replace)
- `suspend`: Suspend the CronJob
- `timeZone`: Timezone for the schedule

### Pod Configuration

| Parameter                       | Description                                      | Default          |
| ------------------------------- | ------------------------------------------------ | ---------------- |
| `podAnnotations`                | Annotations to add to pods                       | `{}`             |
| `podLabels`                     | Labels to add to pods                            | `{}`             |
| `podSecurityContext`            | Security context for pods                        | `{}`             |
| `terminationGracePeriodSeconds` | Grace period for pod termination                 | `null`           |
| `shareProcessNamespace`         | Share process namespace between containers       | `false`          |
| `runtimeClassName`              | RuntimeClass for the pod                         | `""`             |
| `priorityClassName`             | PriorityClass for scheduling                     | `""`             |
| `schedulerName`                 | Scheduler name                                   | `""`             |
| `dnsPolicy`                     | DNS policy                                       | `ClusterFirst`   |
| `dnsConfig`                     | DNS config override                              | `{}`             |
| `readinessGates`                | Additional readiness gates                       | `[]`             |
| `enableServiceLinks`            | Inject service environment variables             | `true`           |
| `topologySpreadConstraints`     | Pod topology spread constraints                  | `[]`             |

### Container Configuration

| Parameter                               | Description                                                | Default                  |
| --------------------------------------- | ---------------------------------------------------------- | ------------------------ |
| `containers[].workingDir`               | Container working directory                                | `""`                     |
| `containers[].securityContext`          | Security context for container                             | `{}`                     |
| `containers[].resources`                | Resource requests and limits                               | `{}`                     |
| `containers[].resizePolicy`             | In-place resize policy for CPU/memory (K8s 1.35 GA)        | `[]`                     |
| `containers[].env`                      | Environment variables                                      | `[]`                     |
| `containers[].envFrom`                  | Environment variables from sources                         | `[]`                     |
| `containers[].volumeMounts`             | Volume mounts                                              | `[]`                     |
| `containers[].livenessProbe`            | Liveness probe configuration                               | `{}`                     |
| `containers[].readinessProbe`           | Readiness probe configuration                              | `{}`                     |
| `containers[].startupProbe`             | Startup probe configuration                                | `{}`                     |
| `containers[].lifecycle`                | Lifecycle hooks                                            | `{}`                     |
| `containers[].terminationMessagePolicy` | Termination message policy                                 | `File`                   |
| `containers[].terminationMessagePath`   | Termination message path                                   | `/dev/termination-log`   |
| `containers[].stdin`                    | Enable stdin                                               | `false`                  |
| `containers[].tty`                      | Allocate a TTY                                             | `false`                  |

### Init Container Configuration

| Parameter                                  | Description                                                       | Default |
| ------------------------------------------ | ----------------------------------------------------------------- | ------- |
| `initcontainers`                           | List of init containers                                           | `[]`    |
| `initcontainers[].restartPolicy`           | Use `Always` to enable stable sidecar containers (K8s 1.33 GA)    | `""`    |
| `initcontainers[].workingDir`              | Init container working directory                                  | `""`    |
| `initcontainers[].livenessProbe`           | Liveness probe configuration                                      | `{}`    |
| `initcontainers[].readinessProbe`          | Readiness probe configuration                                     | `{}`    |
| `initcontainers[].startupProbe`            | Startup probe configuration                                       | `{}`    |
| `initcontainers[].terminationMessagePolicy`| Termination message policy                                        | `File`  |
| `initcontainers[].terminationMessagePath`  | Termination message path                                          | `/dev/termination-log` |
| `initcontainers[].stdin`                   | Enable stdin                                                      | `false` |
| `initcontainers[].tty`                     | Allocate a TTY                                                    | `false` |

### Service Configuration

| Parameter                          | Description         | Default     |
| ---------------------------------- | ------------------- | ----------- |
| `containers[].service.enabled`     | Enable Service      | `false`     |
| `containers[].service.type`        | Service type        | `ClusterIP` |
| `containers[].service.ports`       | Service ports       | `[]`        |
| `containers[].service.annotations` | Service annotations | `{}`        |

### Ingress Configuration

| Parameter                                      | Description                 | Default |
| ---------------------------------------------- | --------------------------- | ------- |
| `containers[].ingress.enabled`                 | Enable Ingress              | `false` |
| `containers[].ingress.className`               | Ingress class name          | `""`    |
| `containers[].ingress.hosts`                   | Ingress hosts configuration | `[]`    |
| `containers[].ingress.tls`                     | TLS configuration           | `[]`    |
| `containers[].ingress.ingressRedirect.enabled` | Enable redirect Ingress     | `false` |

### Configuration Management

| Parameter               | Description                                                  | Default |
| ----------------------- | ------------------------------------------------------------ | ------- |
| `configMap.enabled`     | Enable ConfigMap                                             | `false` |
| `configMap.fileConfigs` | ConfigMap file configurations                                | `[]`    |
| `configEnv.enabled`     | Enable ConfigMap as environment variables                    | `false` |
| `secretEnv.enabled`     | Enable Secret as environment variables                       | `false` |
| `secretEnv.data`        | Secret key/value data rendered via `stringData`              | `""`    |

### Storage Configuration

| Parameter                               | Description                                       | Default         |
| --------------------------------------- | ------------------------------------------------- | --------------- |
| `persistence.enabled`                   | Enable persistent volume                          | `false`         |
| `persistence.storageClass`              | Storage class name                                | `""`            |
| `persistence.accessMode`                | Access mode                                       | `ReadWriteOnce` |
| `persistence.size`                      | Storage size                                      | `10Gi`          |
| `persistence.mountPath`                 | Mount path                                        | `/data`         |
| `persistence.claimRetentionPolicy.whenDeleted` | PVC retention when StatefulSet is deleted | `Retain`        |
| `persistence.claimRetentionPolicy.whenScaled`  | PVC retention when StatefulSet is scaled down | `Retain`        |
| `volumes`                               | Additional volumes                                | `[]`            |

### Auto-scaling Configuration

#### Horizontal Pod Autoscaler (HPA)

| Parameter                                       | Description                    | Default |
| ----------------------------------------------- | ------------------------------ | ------- |
| `autoscaling.enabled`                           | Enable HPA                     | `false` |
| `autoscaling.minReplicas`                       | Minimum replicas               | `1`     |
| `autoscaling.maxReplicas`                       | Maximum replicas               | `100`   |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization         | `""`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization      | `""`    |
| `autoscaling.customRules`                       | Custom metric rules            | `[]`    |
| `autoscaling.behavior`                          | Scaling behavior configuration | `{}`    |

#### KEDA ScaledObject

| Parameter                       | Description                 | Default |
| ------------------------------- | --------------------------- | ------- |
| `scaledObject.enabled`          | Enable KEDA ScaledObject    | `false` |
| `scaledObject.minReplicaCount`  | Minimum replica count       | `1`     |
| `scaledObject.maxReplicaCount`  | Maximum replica count       | `10`    |
| `scaledObject.pollingInterval`  | Polling interval in seconds | `30`    |
| `scaledObject.cooldownPeriod`   | Cooldown period in seconds  | `300`   |
| `scaledObject.idleReplicaCount` | Idle replica count          | `0`     |
| `scaledObject.triggers`         | Scaling triggers            | `[]`    |

### Security Configuration

| Parameter                    | Description                | Default |
| ---------------------------- | -------------------------- | ------- |
| `serviceAccount.create`      | Create ServiceAccount      | `true`  |
| `serviceAccount.name`        | ServiceAccount name        | `""`    |
| `serviceAccount.annotations` | ServiceAccount annotations | `{}`    |
| `NetworkPolicy.enabled`      | Enable NetworkPolicy       | `false` |
| `NetworkPolicy.ingressRules` | Ingress rules              | `[]`    |
| `NetworkPolicy.egressRules`  | Egress rules               | `[]`    |

### High Availability

| Parameter                            | Description                | Default |
| ------------------------------------ | -------------------------- | ------- |
| `podDisruptionBudget.enabled`        | Enable PodDisruptionBudget | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum available pods     | `""`    |
| `podDisruptionBudget.maxUnavailable` | Maximum unavailable pods   | `""`    |
| `podDisruptionBudget.unhealthyPodEvictionPolicy` | PDB unhealthy pod eviction policy | `""` |

### Scheduling Configuration

| Parameter      | Description    | Default |
| -------------- | -------------- | ------- |
| `nodeSelector` | Node selector  | `{}`    |
| `tolerations`  | Tolerations    | `[]`    |
| `affinity`     | Affinity rules | `{}`    |
| `hostAliases`  | Host aliases   | `[]`    |

## Stable Kubernetes Features

This chart currently exposes only **stable GA Kubernetes APIs/features** and includes:

- **Kubernetes 1.33 GA sidecar containers** via `initcontainers[].restartPolicy: Always`
- **Kubernetes 1.35 GA in-place resize policy** via `containers[].resizePolicy`
- **PDB unhealthy pod eviction policy** via `podDisruptionBudget.unhealthyPodEvictionPolicy`
- **StatefulSet PVC retention policy** via `persistence.claimRetentionPolicy`

## Examples

### Basic Deployment

```yaml
kind: Deployment
replicaCount: 2
containers:
  - name: nginx
    image:
      repository: nginx
      tag: "1.21"
    service:
      enabled: true
      type: ClusterIP
      ports:
        - name: http
          port: 80
          targetPort: 80
```

### StatefulSet with Persistent Storage

```yaml
kind: StatefulSet
replicaCount: 3
persistence:
  enabled: true
  size: 20Gi
  storageClass: fast-ssd
containers:
  - name: app
    image:
      repository: myapp
      tag: "v1.0.0"
```

### CronJob Example

```yaml
kind: CronJob
schedule: "0 2 * * *"
timeZone: "America/New_York"
startingDeadlineSeconds: 600
ttlSecondsAfterFinished: 3600
containers:
  - name: backup
    image:
      repository: backup-tool
      tag: "latest"
```

### Deployment with Stable Sidecar

```yaml
kind: Deployment
containers:
  - name: app
    image:
      repository: myapp
      tag: "v1.0.0"
initcontainers:
  - name: log-shipper
    restartPolicy: Always
    image:
      repository: fluent/fluent-bit
      tag: "3.0"
```

### Deployment with In-Place Resize Policy

```yaml
kind: Deployment
containers:
  - name: app
    image:
      repository: myapp
      tag: "v1.0.0"
    resources:
      requests:
        cpu: 250m
        memory: 256Mi
      limits:
        cpu: 1
        memory: 1Gi
    resizePolicy:
      - resourceName: cpu
        restartPolicy: NotRequired
      - resourceName: memory
        restartPolicy: RestartContainer
```

### Deployment with HPA

```yaml
kind: Deployment
replicaCount: 2
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
containers:
  - name: app
    image:
      repository: myapp
      tag: "v1.0.0"
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 500m
        memory: 512Mi
```

### Deployment with Ingress

```yaml
kind: Deployment
containers:
  - name: web
    image:
      repository: nginx
      tag: "1.21"
    service:
      enabled: true
      ports:
        - name: http
          port: 80
          targetPort: 80
    ingress:
      enabled: true
      className: nginx
      hosts:
        - host: example.com
          paths:
            - path: /
              pathType: Prefix
              backend:
                port:
                  number: 80
      tls:
        - secretName: example-tls
          hosts:
            - example.com
```

## Upgrading

To upgrade the release:

```bash
helm upgrade <release-name> novacaap/acute
```

Or with custom values:

```bash
helm upgrade <release-name> novacaap/acute -f my-values.yaml
```

## Uninstalling

To uninstall/delete the release:

```bash
helm uninstall <release-name>
```

## Troubleshooting

### Validate chart before install/upgrade

```bash
helm lint ./acute
helm template my-release ./acute
```

### Check deployment status

```bash
kubectl get pods -l app.kubernetes.io/name=acute
```

### View logs

```bash
kubectl logs -l app.kubernetes.io/name=acute
```

### Describe resources

```bash
kubectl describe deployment <release-name>
```

## Support

For issues, questions, or contributions, please refer to the repository's issue tracker:

- **Repository**: [https://github.com/novacaap/helm-charts](https://github.com/novacaap/helm-charts)
- **Issues**: [https://github.com/novacaap/helm-charts/issues](https://github.com/novacaap/helm-charts/issues)

## License

See the repository for license information.
