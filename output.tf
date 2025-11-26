output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.techcorp_vpc.id
}

output "load_balancer_dns_name" {
  description = "Load Balancer DNS name"
  value       = aws_lb.web_alb.dns_name
}

output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = aws_instance.bastion.public_ip
}
