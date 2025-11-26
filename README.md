# TechCorp Web Application Infrastructure

This Terraform configuration deploys a highly available web application infrastructure on AWS.

## Architecture Overview

- **VPC**: 10.0.0.0/16 with public and private subnets across 2 AZs
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24 (for ALB and Bastion)
- **Private Subnets**: 10.0.3.0/24, 10.0.4.0/24 (for Web and DB servers)
- **NAT Gateways**: For private subnet internet access
- **Application Load Balancer**: Distributes traffic to web servers
- **Bastion Host**: Secure SSH access to private instances
- **Auto-generated SSH Key Pair**: For instance access

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform 1.0 or later

## Deployment Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd techcorp-infrastructure