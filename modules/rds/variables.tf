variable "suffix" {
  type        = string
  description = "Unique postfix for resource names."
}

variable "postgres_engine_version" {
  type        = string
  description = "Postgres engine version."
}

variable "db_username" {
  type        = string
  description = "Master username for the RDS instances."
}

variable "password_sm_arn" {
  type        = string
  description = "Arn or the name of the SecretsManager secret that holds the database password."
}

variable "instance_configuration" {
  type = map(object({
    instance_identifier = string
    instance_class      = string
  }))
  description = "Instance configuration for the RDS instances."
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the RDS instances will be placed."
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key arn for encrypting the RDS instances."
}

variable "db_delete_protection_enabled" {
  type        = bool
  description = "Whether to enable deletion protection for the RDS instances."
}

variable "preferred_backup_window" {
  type        = string
  description = "Daily time range during which automated backups are created if automated backups are enabled using the backup_retention_period parameter."
}

variable "backup_retention_period" {
  type        = number
  description = "The number of days for which automated backups are retained. Default is 5."
}

variable "engine_mode" {
  type        = string
  description = "Engine mode for the RDS instances."

  validation {
    condition     = var.engine_mode == "serverless" || var.engine_mode == "provisioned"
    error_message = "Engine mode must be either 'serverless' or 'provisioned'."
  }
}

variable "serverlessv2_scaling_configuration" {
  type = object({
    max_capacity : number
    min_capacity : number
    seconds_until_auto_pause : optional(number)
  })
  description = "The serverlessv2_scaling_configuration block to use for the RDS cluster"
  default     = null
}

variable "regional_cluster_identifier" {
  type        = string
  description = "The identifier for the regional RDS cluster."
}

variable "subnet_group_name" {
  type        = string
  description = "Name of the DB subnet group."
}

variable "parameter_group_name" {
  type        = string
  description = "Name of the DB parameter group."
}

variable "parameter_group_description" {
  type        = string
  description = "Description of the DB parameter group."
}
