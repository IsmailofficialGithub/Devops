# k8s_manifest_deploy

Build + push image to Docker Hub, then `kubectl apply` raw manifests (image tag updated in CI).

## Secrets

- `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`
- `KUBE_CONFIG` — base64-encoded kubeconfig
