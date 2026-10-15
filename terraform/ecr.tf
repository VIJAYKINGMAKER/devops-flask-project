resource "aws_ecr_repository" "app" {
  name                 = "${local.project_name}-${local.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-ecr"
  })
}

output "ecr_repository_url" {
  description = "URL of the application container image repository"
  value       = aws_ecr_repository.app.repository_url
}
