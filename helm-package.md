# Helm package and Index acute

```
helm package acute
mv acute-* docs
helm repo index docs --url https://khanarshad23.github.io/Helm-Chart/
```

# Add Helm Repo

```
helm repo add acute https://khanarshad23.github.io/Helm-Chart/
helm search repo acute
```
