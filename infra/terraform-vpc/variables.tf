variable "aws_region" {
  type        = string
  description = "The target AWS deployment region"
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  type        = string
  description = "The root CIDR block configuration for the parent network"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The allocation perimeter for the public tier"
  default     = "10.1.1.0/24"
}
