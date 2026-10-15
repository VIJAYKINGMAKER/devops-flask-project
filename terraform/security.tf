
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
# Security group for the public Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "${local.project_name}-${local.environment}-alb-sg"
  description = "Allow public HTTPS traffic to the application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Forward traffic to the Flask application"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-alb-sg"
  })
}
# Allow Flask traffic only from the ALB security group
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id

  description = "Allow Flask traffic from the ALB only"
  ip_protocol = "tcp"
  from_port   = 5000
  to_port     = 5000
}