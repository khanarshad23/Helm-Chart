# Helm Charts Repository

This repository contains Helm charts for deploying applications to Kubernetes. Helm is a package manager for Kubernetes that simplifies the deployment and management of applications.

## What is Helm?

Helm is the package manager for Kubernetes. It helps you:

- **Package applications**: Bundle Kubernetes resources into reusable charts
- **Manage dependencies**: Handle complex application dependencies
- **Version management**: Track and manage different versions of your applications
- **Simplify deployments**: Deploy complex applications with a single command
- **Configuration management**: Customize deployments using values files

### Key Concepts

- **Chart**: A collection of files that describe a related set of Kubernetes resources
- **Release**: An instance of a chart running in a Kubernetes cluster
- **Repository**: A location where packaged charts are stored and shared
- **Values**: Configuration parameters that customize chart deployments

## Prerequisites

Before using Helm, ensure you have:

- **Kubernetes cluster** (1.19+)
- **kubectl** configured to access your cluster
- **Helm 3.0+** installed

### Installing Helm

#### macOS

```bash
brew install helm
```

#### Linux

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

#### Windows

```powershell
choco install kubernetes-helm
```

#### Verify Installation

```bash
helm version
```

## Repository Setup

### Add This Repository

```bash
helm repo add khanarshad23 https://khanarshad23.github.io/Helm-Chart/
helm repo update
```

### List Available Charts

```bash
helm search repo khanarshad23
```

## Available Charts

This repository contains the following Helm charts:

- **acute**: A flexible Helm chart supporting Deployments, StatefulSets, Jobs, and CronJobs with extensive configuration options

For detailed documentation on each chart, see their respective README files in the chart directories.

## Essential Helm Commands

### Repository Commands

#### Add a Repository

```bash
helm repo add <repo-name> <repo-url>
```

Example:

```bash
helm repo add khanarshad23 https://khanarshad23.github.io/Helm-Chart/
```

#### List Repositories

```bash
helm repo list
```

#### Update Repository Index

```bash
helm repo update
```

#### Remove a Repository

```bash
helm repo remove <repo-name>
```

#### Search Charts

```bash
# Search in all repositories
helm search repo <keyword>

# Search in a specific repository
helm search repo <repo-name>/<chart-name>
```

### Installation Commands

#### Install a Chart

```bash
helm install <release-name> <repo-name>/<chart-name>
```

Example:

```bash
helm install my-app khanarshad23/acute
```

#### Install with Custom Values

```bash
helm install <release-name> <repo-name>/<chart-name> -f values.yaml
```

#### Install with Inline Values

```bash
helm install <release-name> <repo-name>/<chart-name> \
  --set key1=value1 \
  --set key2=value2
```

#### Install to Specific Namespace

```bash
helm install <release-name> <repo-name>/<chart-name> -n <namespace> --create-namespace
```

#### Install with Dry Run (Preview)

```bash
helm install <release-name> <repo-name>/<chart-name> --dry-run --debug
```

### Upgrade Commands

#### Upgrade a Release

```bash
helm upgrade <release-name> <repo-name>/<chart-name>
```

#### Upgrade with Values File

```bash
helm upgrade <release-name> <repo-name>/<chart-name> -f values.yaml
```

#### Upgrade with Rollback on Failure

```bash
helm upgrade <release-name> <repo-name>/<chart-name> --atomic
```

#### Upgrade with Timeout

```bash
helm upgrade <release-name> <repo-name>/<chart-name> --timeout 5m
```

### List and Status Commands

#### List All Releases

```bash
helm list
```

#### List Releases in Namespace

```bash
helm list -n <namespace>
```

#### List All Releases (Including Deleted)

```bash
helm list --all
```

#### Show Release Status

```bash
helm status <release-name>
```

#### Show Release History

```bash
helm history <release-name>
```

### Uninstall Commands

#### Uninstall a Release

```bash
helm uninstall <release-name>
```

#### Uninstall with Keep History

```bash
helm uninstall <release-name> --keep-history
```

### Rollback Commands

#### Rollback to Previous Version

```bash
helm rollback <release-name>
```

#### Rollback to Specific Revision

```bash
helm rollback <release-name> <revision-number>
```

### Template and Debug Commands

#### Render Templates Locally

```bash
helm template <release-name> <repo-name>/<chart-name>
```

#### Render with Values

```bash
helm template <release-name> <repo-name>/<chart-name> -f values.yaml
```

#### Validate Chart

```bash
helm lint <chart-path>
```

#### Show Chart Values

```bash
helm show values <repo-name>/<chart-name>
```

#### Show Chart Information

```bash
helm show chart <repo-name>/<chart-name>
```

#### Show All Chart Information

```bash
helm show all <repo-name>/<chart-name>
```

### Package Commands

#### Package a Chart

```bash
helm package <chart-path>
```

#### Package with Version

```bash
helm package <chart-path> --version 1.0.0
```

#### Create Index File

```bash
helm repo index <directory>
```

## Common Workflows

### Basic Deployment Workflow

1. **Add the repository**

```bash
   helm repo add khanarshad23 https://khanarshad23.github.io/Helm-Chart/
   helm repo update
```

2. **Search for charts**

```bash
   helm search repo khanarshad23
```

3. **View chart values**

```bash
   helm show values khanarshad23/acute
```

4. **Create custom values file**

```bash
   helm show values khanarshad23/acute > my-values.yaml
   # Edit my-values.yaml with your configuration
```

5. **Install the chart**

```bash
   helm install my-release khanarshad23/acute -f my-values.yaml
```

6. **Check status**

```bash
   helm status my-release
   kubectl get pods
```

7. **Upgrade when needed**

```bash
   helm upgrade my-release khanarshad23/acute -f my-values.yaml
```

8. **Rollback if needed**
```bash
   helm rollback my-release
```

### Development Workflow

1. **Clone and modify chart locally**

```bash
   git clone https://github.com/khanarshad23/Helm-Chart.git
   cd Helm-Chart/acute
   # Make your changes
```

2. **Lint the chart**

```bash
   helm lint .
```

3. **Test with dry-run**

```bash
   helm install test-release . --dry-run --debug
```

4. **Package the chart**

```bash
   helm package .
```

5. **Test installation**
```bash
   helm install test-release ./acute-1.0.0.tgz
```

## Values Files

Values files allow you to customize chart deployments. You can:

- Use default values from the chart
- Override with `-f values.yaml`
- Override with `--set key=value`
- Combine multiple values files: `-f values1.yaml -f values2.yaml`
- Use `--set-file` for file contents: `--set-file config=config.yaml`

### Values Precedence

1. `--set` command line arguments (highest priority)
2. `-f` or `--values` files
3. Chart's `values.yaml` (lowest priority)

## Best Practices

1. **Always use values files** for production deployments
2. **Version your values files** in version control
3. **Use namespaces** to organize releases
4. **Test with dry-run** before actual deployment
5. **Keep release names descriptive** and consistent
6. **Use `--atomic` flag** for critical upgrades
7. **Monitor releases** with `helm status` and `kubectl`
8. **Document custom values** for team knowledge sharing

## Troubleshooting

### Check Release Status

```bash
helm status <release-name>
```

### View Release Manifest

```bash
helm get manifest <release-name>
```

### View Release Values

```bash
helm get values <release-name>
```

### View All Release Information

```bash
helm get all <release-name>
```

### Debug Template Rendering

```bash
helm template <release-name> <chart> --debug
```

### Check Kubernetes Resources

```bash
kubectl get all -l app.kubernetes.io/instance=<release-name>
```

### View Pod Logs

```bash
kubectl logs -l app.kubernetes.io/instance=<release-name>
```

### Describe Resources

```bash
kubectl describe pod -l app.kubernetes.io/instance=<release-name>
```

## Useful Tips

- Use `helm list -A` to see releases across all namespaces
- Use `helm uninstall --dry-run` to preview what will be deleted
- Use `helm diff` plugin to see changes before upgrading
- Use `helm test` to run test hooks after installation
- Use `helm dependency update` when charts have dependencies

## Additional Resources

- [Helm Official Documentation](https://helm.sh/docs/)
- [Helm Chart Best Practices](https://helm.sh/docs/chart_best_practices/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Hub](https://artifacthub.io/)

## Repository Information

- **Repository URL**: [https://github.com/khanarshad23/Helm-Chart](https://github.com/khanarshad23/Helm-Chart)
- **Helm Repository**: `https://khanarshad23.github.io/Helm-Chart/`
- **Issues**: [https://github.com/khanarshad23/Helm-Chart/issues](https://github.com/khanarshad23/Helm-Chart/issues)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See individual chart directories for license information.
