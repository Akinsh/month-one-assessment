TechCorp AWS Infrastructure Deployment
This Terraform configuration deploys a highly available web application infrastructure on AWS with secure network architecture and load balancing capabilities.

Table of Contents
Project Overview

Architecture

Prerequisites

Infrastructure Components

Deployment Steps

Accessing the Infrastructure

Verification

Cleanup Instructions

Project Overview
This infrastructure implements a production-ready AWS environment for TechCorp's web application with:

High Availability: Multi-AZ deployment across two availability zones

Secure Network Isolation: Public and private subnets with controlled access

Load Balancing: Application Load Balancer for traffic distribution

Secure Access: Bastion host for administrative access

Scalable Architecture: Designed for future growth

Architecture
Network Design
VPC: 10.0.0.0/16 (techcorp-vpc)

Public Subnets:

techcorp-public-subnet-1: 10.0.1.0/24 (AZ1)

techcorp-public-subnet-2: 10.0.2.0/24 (AZ2)

Private Subnets:

techcorp-private-subnet-1: 10.0.3.0/24 (AZ1)

techcorp-private-subnet-2: 10.0.4.0/24 (AZ2)

Compute Resources
Bastion Host: t3.micro in public subnet with Elastic IP

Web Servers: 2x t3.micro instances in private subnets (Apache)

Database Server: t3.small in private subnet (PostgreSQL)

Security Groups
Bastion: SSH access from your IP only

Web: HTTP/HTTPS from anywhere, SSH from Bastion

Database: PostgreSQL (3306) from Web servers, SSH from Bastion

Prerequisites
Required Tools
AWS Account with appropriate permissions

Terraform 1.0 or later

AWS CLI configured

SSH client

AWS Configuration
Configure AWS CLI with your credentials:

bash
aws configure
Create an EC2 key pair in your preferred region

Note your public IP address for bastion access

Infrastructure Components
Resources Created
Networking: VPC, Subnets, Internet Gateway, NAT Gateways, Route Tables

Security: Security Groups, Network ACLs

Compute: EC2 Instances (Bastion, Web Servers, Database)

Load Balancing: Application Load Balancer, Target Group, Listener

Deployment Steps
Step 1: Clone and Prepare
bash
git clone <repository-url>
cd terraform-assessment
Step 2: Configure Variables
bash
cp terraform.tfvars.example terraform.tfvars
Edit terraform.tfvars with your actual values:

hcl
region               = "us-east-1"
web_instance_type    = "t3.micro"
bastion_instance_type = "t3.micro"
db_instance_type     = "t3.small"
key_pair_name        = "your-key-pair-name"
my_ip                = "YOUR_IP_ADDRESS/32"

Step 3: Initialize Terraform
bash
terraform init
Step 4: Validate Configuration
bash
terraform validate
Step 5: Preview Deployment
bash
terraform plan
Step 6: Deploy Infrastructure
bash
terraform apply
Type yes when prompted to confirm deployment.

Step 7: Save Outputs
bash
terraform output > deployment-outputs.txt
Accessing the Infrastructure
Web Application Access
After deployment, access your web application using the Load Balancer DNS name:

bash
echo "Web Application URL: http://$(terraform output -raw load_balancer_dns_name)"
Bastion Host Access
bash
# Using SSH key
ssh -i your-key.pem ec2-user@$(terraform output -raw bastion_public_ip)

# Using password (if configured)
ssh ec2-user@$(terraform output -raw bastion_public_ip)
Accessing Web Servers from Bastion
bash
# From your local machine, connect to bastion
ssh -i your-key.pem ec2-user@<bastion-ip>

# From bastion, connect to web servers
ssh ec2-user@<web-server-private-ip>

# Check Apache status
sudo systemctl status httpd

# Test web server locally
curl http://localhost
Accessing Database Server
bash
# From bastion, connect to database server
ssh ec2-user@<database-server-private-ip>

# Connect to PostgreSQL
sudo -u postgres psql -d techcorpdb

# Test database connection
\l                    # List databases
\c techcorpdb         # Connect to database
\dt                   # List tables
SELECT version();     # Test query
\q                    # Exit
Verification
Load Balancer Test
Access the ALB URL in your web browser

Refresh multiple times to see different web servers responding

Verify both servers are healthy in AWS Console (EC2 → Target Groups)

Health Checks
bash
# Test load balancer health checks
curl -I http://$(terraform output -raw load_balancer_dns_name)/health.html
Infrastructure Verification
Check AWS Console for:

✅ All EC2 instances in "running" state

✅ Load Balancer shows as "active"

✅ Target Group shows both targets as "healthy"

✅ NAT Gateways are "available"

Cleanup Instructions
Destroy Infrastructure
To avoid ongoing charges, destroy all resources when finished:

bash
# Preview destruction
terraform plan -destroy

# Destroy all resources
terraform destroy
Type yes when prompted to confirm destruction.

Post-Destruction Verification
Check AWS Console to ensure:

EC2 instances are terminated

Load Balancer is deleted

NAT Gateways are deleted

Elastic IPs are released

Clean local files:

bash
rm -rf .terraform terraform.tfstate* deployment-outputs.txt
File Structure
text
terraform-assessment/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output values
├── terraform.tfvars.example # Example variable file
├── user_data/
│   ├── web_server_setup.sh # Apache installation script
│   └── db_server_setup.sh  # PostgreSQL installation script
└── README.md              # This documentation
Security Notes
Bastion host only accessible from your specified IP

Web servers are in private subnets with no direct internet access

Database server only accessible from web servers and bastion

All instances use security groups with minimum required access

Cost Optimization
Use terraform destroy when not testing to avoid charges

Consider using spot instances for non-production workloads

Monitor AWS Cost Explorer for unexpected charges

Support
For issues with this deployment:

Check Terraform validation outputs

Verify AWS region and credential configuration

Ensure all variables in terraform.tfvars are correctly set

Check AWS service limits in your account


Oluwatobiloba Akinseye | AltSchool | Cloud Engineering
