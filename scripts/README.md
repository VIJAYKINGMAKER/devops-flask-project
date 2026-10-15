# Container Deployment

This script deploys the Flask application using a published Docker image.

## Usage

```bash
bash scripts/deploy-container.sh ghcr.io/vijaykingmaker/devops-flask-project:latest
```

## Requirements

- Docker installed and running on the deployment host.
- Access to the selected container image.
- Secure registry authentication if the image is private.

## Security Notes

- Never store registry credentials in this script or Terraform files.
- The application port binds to localhost by default.
- Configure a reverse proxy or load balancer before exposing the service publicly.

## Important

The script replaces an existing container before starting the new one. Production deployments should include health checks and a rollback strategy.# Container Deployment

This script deploys the Flask application using a published Docker image.

## Usage

```bash
bash scripts/deploy-container.sh ghcr.io/vijaykingmaker/devops-flask-project:latest
```

## Requirements

- Docker installed and running on the deployment host.
- Access to the selected container image.
- Secure registry authentication if the image is private.

## Security Notes

- Never store registry credentials in this script or Terraform files.
- The application port binds to localhost by default.
- Configure a reverse proxy or load balancer before exposing the service publicly.

## Important

The script replaces an existing container before starting the new one. Production deployments should include health checks and a rollback strategy.