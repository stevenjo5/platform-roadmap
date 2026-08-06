# Automated Multi-AZ Core Network Topology Specification

# 1. Initialize the Global VPC Perimeter Network Pool
resource "aws_vpc" "platform_vpc" {
  cidr_block           = "10.0.0.0/16" # Allocates up to 65,536 private cluster IP spaces
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "platform-production-vpc"
    Tier = "core-infrastructure"
  }
}

# 2. Provision Isolated Public Subnet Layers Across 3 Separate Availability Zones
resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.platform_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = { Name = "platform-public-eu-west-2a" }
}

resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.platform_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = { Name = "platform-public-eu-west-2b" }
}

resource "aws_subnet" "public_az3" {
  vpc_id            = aws_vpc.platform_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2c"
  map_public_ip_on_launch = true

  tags = { Name = "platform-public-eu-west-2c" }
}

# 3. Provision Insulated Private Subnet Layers Across 3 Separate Availability Zones
resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.platform_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-west-2a"

  tags = { Name = "platform-private-eu-west-2a" }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.platform_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "eu-west-2b"

  tags = { Name = "platform-private-eu-west-2b" }
}

resource "aws_subnet" "private_az3" {
  vpc_id            = aws_vpc.platform_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "eu-west-2c"

  tags = { Name = "platform-private-eu-west-2c" }
}

# ==========================================
# EDGE GATEWAYS & ROUTING CONFIGURATIONS (Day 104)
# ==========================================

# 1. Provision an Internet Gateway for Public Ingress Communications
resource "aws_internet_gateway" "platform_igw" {
  vpc_id = aws_vpc.platform_vpc.id
  tags   = { Name = "platform-production-igw" }
}

# 2. Allocate a Static Public IP (Elastic IP) to Anchor the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.platform_igw]
  tags       = { Name = "platform-nat-static-ip" }
}

# 3. Provision a Secure NAT Gateway Inside the First Public Subnet Area
resource "aws_nat_gateway" "platform_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_az1.id # Anchored securely inside public zone A
  depends_on    = [aws_internet_gateway.platform_igw]
  tags          = { Name = "platform-secure-nat-gateway" }
}

# 4. Formulate the Public Route Table (Points Direct to the Internet Bridge)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.platform_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Targets all external internet destinations
    gateway_id = aws_internet_gateway.platform_igw.id
  }
  tags = { Name = "platform-public-route-table" }
}

# 5. Formulate the Private Route Table (Points Direct to the NAT Gateway Firewall)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.platform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.platform_nat.id
  }
  tags = { Name = "platform-private-route-table" }
}

# 6. Map the Public Subnets to the Public Ingress Route Table Matrix
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_assoc_3" {
  subnet_id      = aws_subnet.public_az3.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Map the Private Subnets to the Private Egress Route Table Matrix
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_assoc_3" {
  subnet_id      = aws_subnet.private_az3.id
  route_table_id = aws_route_table.private_rt.id
}
