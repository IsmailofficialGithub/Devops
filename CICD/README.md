# CICD — 10 GitHub Actions projects

Each folder is a standalone CI/CD scenario you can copy into a repo (or keep as reference workflows).

| # | Project | What it does |
|---|---|---|
| 1 | `artifact_build` | Build app → upload GitHub Actions artifact |
| 2 | `release_assets` | Tag release → attach build assets to GitHub Release |
| 3 | `docker_hub_push` | Build Docker image → push to Docker Hub |
| 4 | `docker_multi_arch` | Multi-arch (`amd64`/`arm64`) image → Docker Hub |
| 5 | `matrix_test_build` | Matrix test + build artifact on pass |
| 6 | `code_update_pr` | Bot updates version/code → opens Pull Request |
| 7 | `k8s_manifest_deploy` | Build/push image → apply raw K8s manifests |
| 8 | `k8s_helm_deploy` | Build/push image → Helm upgrade |
| 9 | `k8s_kustomize_deploy` | Build/push image → Kustomize apply |
| 10 | `full_cicd_pipeline` | Artifact + Docker Hub + K8s deploy (end-to-end) |

## Common secrets

| Secret | Used by |
|---|---|
| `DOCKERHUB_USERNAME` | Docker / K8s projects |
| `DOCKERHUB_TOKEN` | Docker / K8s projects |
| `KUBE_CONFIG` | K8s projects (base64 kubeconfig) |
| `GITHUB_TOKEN` | Built-in (artifacts, releases, PRs) |

## How to try one

```bash
# copy a project workflow into a real repo:
cp -r CICD/docker_hub_push/.github your-repo/
cp -r CICD/docker_hub_push/app your-repo/
# add secrets in GitHub → Settings → Secrets and variables → Actions
```
