resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_app.name
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

   # Docker and AWS CLI must already be installed in the AMI.
    systemctl enable --now docker

    AWS_REGION="${var.aws_region}"
    ECR_REPOSITORY="${aws_ecr_repository.app.repository_url}"
    IMAGE="$ECR_REPOSITORY:main"

    aws ecr get-login-password --region "$AWS_REGION" \
      | docker login --username AWS --password-stdin "$ECR_REPOSITORY"

    docker pull "$IMAGE"

    docker run -d \
      --name devops-flask-project \
      --restart unless-stopped \
      -p 5000:5000 \
      "$IMAGE"
  EOF

  user_data_replace_on_change = true

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-app"
  })
}
