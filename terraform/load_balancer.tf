# Public Application Load Balancer
resource "aws_lb" "app" {
  name               = "${local.project_name}-${local.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-alb"
  })
}

# Forward HTTP application traffic to Flask on EC2
resource "aws_lb_target_group" "app" {
  name        = "${local.project_name}-${local.environment}-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-${local.environment}-tg"
  })
}

# Register the EC2 application with the target group
resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app.id
  port             = 5000
}

# Accept HTTPS and forward requests to the Flask target group
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}