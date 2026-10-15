
# Trust policy: allow EC2 to assume this role.
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role for the future EC2 application instance.
resource "aws_iam_role" "ec2_app" {
  name               = "${local.project_name}-${local.environment}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-ec2-role"
  })
}

# Instance profile makes the IAM role usable by EC2.
resource "aws_iam_instance_profile" "ec2_app" {
  name = "${local.project_name}-${local.environment}-ec2-profile"
  role = aws_iam_role.ec2_app.name

  tags = local.common_tags
}

# Allow the EC2 role to pull application images from ECR.
data "aws_iam_policy_document" "ecr_pull" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [aws_ecr_repository.app.arn]
  }
}

resource "aws_iam_role_policy" "ecr_pull" {
  name   = "${local.project_name}-${local.environment}-ecr-pull"
  role   = aws_iam_role.ec2_app.id
  policy = data.aws_iam_policy_document.ecr_pull.json
}
