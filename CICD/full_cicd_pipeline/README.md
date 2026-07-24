# full_cicd_pipeline

End-to-end pipeline:

1. Test + build → upload **GitHub artifact**
2. Build Docker image → push **Docker Hub**
3. Deploy to **Kubernetes** (manifests)
4. Optional: open PR note / update image tag file in repo
