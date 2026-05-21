terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Calling the Custom Reusable VPC Module Package
module "vpc_network" {
  source = "../../platform-roadmap/modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  project_slug       = "platform-core"
  environment        = terraform.workspace
}

output "module_vpc_id" {
  value = module.vpc_network.vpc_id
}
