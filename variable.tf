variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "web_instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t3.micro"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "EC2 instance type for database server"
  type        = string
  default     = "t3.small"
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
  default     = "techcorp-key"
}

variable "my_ip" {
  description = "Your IP address for bastion access (e.g., 192.168.1.100/32)"
  type        = string
  default     = "0.0.0.0/0"
}
