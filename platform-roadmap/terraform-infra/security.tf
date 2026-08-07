# Automated Cloud Security Group & Traffic Matrix Specification

# 1. Initialize the Public Load Balancer Security Group Firewall
resource "aws_security_group" "load_balancer_sg" {
  name        = "platform-production-alb-sg"
  description = "Controls public internet ingress access paths to the application load balancers"
  vpc_id      = aws_vpc.platform_vpc.id

  # Allow Global Ingress HTTP Traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the public internet
  }

  # Allow Global Ingress HTTPS Traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Unrestricted Outbound Egress Routing
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "platform-alb-security-group" }
}

# 2. Initialize the Insulated Kubernetes Worker Node Security Group Firewall
resource "aws_security_group" "worker_node_sg" {
  name        = "platform-production-nodes-sg"
  description = "Insulates cluster worker nodes from direct external public internet paths"
  vpc_id      = aws_vpc.platform_vpc.id

  # Restrict Node Ingress Access - Only Allow Ingress from the Internal Load Balancer
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id] # Explicit source locking
  }

  # Allow Internal Node-to-Node Cluster Cross Communication (All Ports within the VPC)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.platform_vpc.cidr_block] # Locked to 10.0.0.0/16
  }

  # Unrestricted Outbound Egress (Allows nodes to talk outward via the NAT Gateway)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "platform-node-security-group" }
}
