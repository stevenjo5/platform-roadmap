terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

# 1. Parent VPC Container
resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Terraform-VPC"
  }
}

# 2. Public Subnet Tier
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform-Public-Subnet"
  }
}

# 3. Internet Edge Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Terraform-IGW"
  }
}

# 4. Routing Table Architecture
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Terraform-Public-RT"
  }
}

# 5. Route Table Subnet Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 6. Stateful Perimeter Security Group (Firewall)
resource "aws_security_group" "web" {
  name        = "terraform-web-sg"
  description = "Allow inbound management traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH connectivity"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Web-SG"
  }
}

# 7. Automated Compute Instance (The Server)
resource "aws_instance" "app_server" {
  ami                    = "ami-0e8d228ad90af673b" # Amazon Linux 2023 (London)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = "Platform-Key"

  tags = {
    Name = "Terraform-App-Server"
  }
}

# Output Metadata Schema Variables
output "vpc_id" {
  description = "The ID of our automated VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The ID of our public subnet tier"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "The ID of our production web security firewall"
  value       = aws_security_group.web.id
}

output "server_public_ip" {
  description = "The public IP address of our production application server"
  value       = aws_instance.app_server.public_ip
}
