# 1. Parent VPC Container
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_slug}-vpc-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform-module"
  }
}

# 2. Public Subnet Tier
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_slug}-public-subnet-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform-module"
  }
}

# 3. Internet Edge Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_slug}-igw-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform-module"
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
    Name        = "${var.project_slug}-public-rt-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform-module"
  }
}

# 5. Route Table Subnet Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 6. Stateful Perimeter Security Group (Firewall)
resource "aws_security_group" "web" {
  name        = "${var.project_slug}-web-sg-${var.environment}"
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
    Name        = "${var.project_slug}-web-sg-${var.environment}"
    Environment = var.environment
    ManagedBy   = "terraform-module"
  }
}
