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
