variable "region" {
  type        = string
  description = "AWS region to deploy resources."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources."
  default     = {}
}

variable "unique_suffix" {
  type        = string
  description = "A unique suffix to append to resource names. Ideally passed from the terraform-aws-spacelift-selfhosted module's outputs."
  default     = ""
}

variable "kms_arn" {
  type        = string
  description = "ARN of the KMS key to use for encryption: S3 buckets, RDS instances, and ECR repositories. If empty, a new KMS key will be created."
  default     = null
}

variable "create_vpc" {
  type        = bool
  description = "Whether to create a VPC for the Spacelift resources. Default is true. Note: if this is false, and create_database is true, you must provide rds_subnet_ids and rds_security_group_ids."
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block to use for the VPC created for Spacelift. The subnet mask must be between /16 and /24."
  default     = "10.0.0.0/24"
}

variable "rds_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to use for the RDS instances. If create_vpc is false, this must be provided."
  default     = []
}

variable "rds_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to use for the RDS instances. If create_vpc is false, this must be provided."
  default     = []
}

variable "rds_serverlessv2_scaling_configuration" {
  type = object({
    max_capacity : number
    min_capacity : number
    seconds_until_auto_pause : optional(number)
  })
  description = "The serverlessv2_scaling_configuration block to use for the RDS cluster"
  default     = null
}

variable "create_database" {
  type        = bool
  description = "Whether to create the Aurora RDS database. Default is true."
  default     = true
}

variable "rds_delete_protection_enabled" {
  type        = bool
  description = "Whether to enable deletion protection for the RDS instances."
  default     = true
}

variable "rds_engine_version" {
  type        = string
  description = "Postgres engine version."
  default     = "16.6"
}

variable "rds_engine_mode" {
  type        = string
  description = "Engine mode for the RDS instances. Default is 'provisioned'. Can be either 'serverless' or 'provisioned'."
  default     = "provisioned"

  validation {
    condition     = var.rds_engine_mode == "serverless" || var.rds_engine_mode == "provisioned"
    error_message = "Engine mode must be either 'serverless' or 'provisioned'."
  }
}

variable "rds_username" {
  type        = string
  description = "Master username for the RDS instances. Note: this won't be used by the application, but it's required by the RDS resource."
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

variable "rds_preferred_backup_window" {
  type        = string
  description = "Daily time range during which automated backups are created if automated backups are enabled using the rds_backup_retention_period parameter."
  default     = "07:00-09:00"
}

variable "rds_backup_retention_period" {
  type        = number
  description = "The number of days for which automated backups are retained. Default is 3."
  default     = 3
}

variable "website_domain" {
  type        = string
  description = "The hostname of the Spacelift website. Should include protocol (https://). This is being used for state uploads during Stack creations. Example: https://spacelift.mycorp.com. If this isn't known at the time of the deployment, it can be set later."
  default     = ""
}

variable "s3_retain_on_destroy" {
  type        = bool
  description = "Whether to retain the S3 buckets' contents when destroyed. If true, and the S3 bucket isn't empty, the deletion will fail."
  default     = true
}

variable "number_of_images_to_retain" {
  type        = number
  description = "Number of Docker images to retain in ECR repositories. Default is 5. If set to 0, no images will be cleaned up."
  default     = 5
}
