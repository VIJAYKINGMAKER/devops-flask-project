
output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.main.id
}

output "load_balancer_dns_name" {
  description = "DNS name of the public Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "private_instance_ip" {
  description = "Private IP address of the Flask EC2 instance"
  value       = aws_instance.app.private_ip
}
