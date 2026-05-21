variable "vpc_cidr" {
  type        = string
  description = "The CIDR block allocation for the network"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The CIDR block allocation for the public subnet tier"
}

variable "project_slug" {
  type        = string
  description = "A standard prefix string for resource mapping"
}

variable "environment" {
  type        = string
  description = "The deployment stage target tag"
}
