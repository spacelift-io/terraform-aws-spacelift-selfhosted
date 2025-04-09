variable "suffix" {
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

variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether DNS hostnames should be enabled on the VPC or not."
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for the public subnets."
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for the private subnets."
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Custom tags to apply to the public subnets."
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Custom tags to apply to the private subnets."
}
