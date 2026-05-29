terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Migrating state file from local memory to the AWS Cloud
  backend "s3" {
    bucket         = "stevenjo5-terraform-state-2026"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Consume the Encapsulated Custom Network Module
module "vpc_network" {
  source = "../../platform-roadmap/modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  project_slug       = "platform-core"
  environment        = terraform.workspace
}

# 2. Automated Compute Instance Linked to Module Outputs
resource "aws_instance" "app_server" {
  ami                    = "ami-0e8d228ad90af673b"
  instance_type          = "t3.micro"
  subnet_id              = module.vpc_network.subnet_id
  vpc_security_group_ids = [module.vpc_network.security_group_id]
  key_name               = "Platform-Key-V2"

  tags = {
    Name        = "platform-core-server-${terraform.workspace}"
    Environment = terraform.workspace
    ManagedBy   = "terraform-root"
  }
}

# Output Metadata Variables
output "root_server_public_ip" {
  description = "The live public IP of our production modular server"
  value       = aws_instance.app_server.public_ip
}
