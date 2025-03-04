variable "seed" {
  type        = string
  description = "Unique postfix for resource names."
}

variable "create_database" {
  type        = bool
  description = "Whether to create a database for Spacelift"
}

variable "vpc_cidr_block" {
  description = "The CIDR block to use for the VPC created for Spacelift"
}

