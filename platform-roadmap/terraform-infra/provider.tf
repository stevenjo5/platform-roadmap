# Enterprise Cloud Provider Mapping Specification

terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Initialize the target cloud provider integration module scope
provider "aws" {
  region = "eu-west-2" # London datacenter region cluster footprint
}
