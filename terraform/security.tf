
# Security group for the future Flask EC2 instance.
# No inbound rules are opened to the public internet yet.
resource "aws_security_group" "app" {
  name        = "${local.project_name}-${local.environment}-app-sg"
  description = "Security group for the Flask application"
  vpc_id      = aws_vpc.main.id

  # Allow outbound traffic for OS updates and application dependencies.
  egress {
    description = "Allow outbound IPv4 traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-app-sg"
  })
}
