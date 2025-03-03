variable "vpc_cidr_block" {
  default     = "10.0.0.0/24"
  description = "The CIDR block to use for the VPC created for Spacelift"
}

variable "subnet_mask_size" {
  default     = 5
  description = "The mask to use when generating CIDRs for each subnet"
}
