# Optional local sample — ECS defaults to public nginx image.
# Build/push your own:
#   docker build -t myapp .
#   aws ecr get-login-password | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com
#   docker tag myapp:latest <repo_url>:latest
#   docker push <repo_url>:latest
FROM nginx:1.27-alpine
COPY index.html /usr/share/nginx/html/index.html
