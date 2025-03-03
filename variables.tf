variable "region" {
  type        = string
  description = "AWS region to deploy resources."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources."
  default     = {}
}

variable "kms_arn" {
  type        = string
  description = "ARN of the KMS key to use for encryption: S3 buckets, RDS instances, and ECR repositories. If empty, a new KMS key will be created."
  default     = null
}

variable "create_vpc" {
  type        = bool
  description = "Whether to create a VPC for the Spacelift resources. Default is true."
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block to use for the VPC created for Spacelift."
  default     = "10.0.0.0/24"
}

variable "subnet_mask_size" {
  type        = number
  description = "The mask to use when generating CIDRs for each subnet."
  default     = 5
}

variable "rds_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to use for the RDS instances."
  default     = []
}

variable "rds_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to use for the RDS instances."
  default     = []
}

variable "create_database" {
  type        = bool
  description = "Whether to create the RDS database. Default is true."
  default     = true
}

variable "rds_delete_protection_enabled" {
  type        = bool
  description = "Whether to enable deletion protection for the RDS instances."
  default     = true
}

variable "rds_engine_version" {
  type        = string
  description = "Postgres engine version. Default is 14.13. If you change this, make sure to update postgres_family accordingly."
  default     = "14.13"
}

variable "rds_engine_mode" {
  type        = string
  description = "Engine mode for the RDS instances. Default is 'provisioned'."
  default     = "provisioned"

  validation {
    condition     = var.rds_engine_mode == "serverless" || var.rds_engine_mode == "provisioned"
    error_message = "Engine mode must be either 'serverless' or 'provisioned'."
  }
}

variable "rds_username" {
  type        = string
  description = "Master username for the RDS instances."
  default     = "spacelift"
}

variable "rds_instance_configuration" {
  type = map(object({
    instance_identifier = string
    instance_class      = string
  }))
  description = "Instance configuration for the RDS instances. Default is a single db.r6g.large instance."
  default = {
    "primary-instance" = {
      instance_identifier = "primary"
      instance_class      = "db.r6g.large"
    }
  }
}

variable "number_of_images_to_retain" {
  type        = number
  description = "Number of images to retain in ECR repositories. Default is 5. If set to 0, no images will be deleted."
  default     = 5
}
