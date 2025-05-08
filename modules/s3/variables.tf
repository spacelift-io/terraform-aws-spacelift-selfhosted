variable "suffix" {
  type        = string
  description = "Unique postfix for resource names."
}

variable "kms_master_key_arn" {
  type        = string
  description = "ARN of the KMS key to use for server-side encryption."
}

variable "cors_hostname" {
  type        = string
  description = "The hostname of the deployment. Should include protocol (https://). This is being used for state uploads during Stack creations. Example: https://spacelift.mycorp.com"
}

variable "retain_on_destroy" {
  type        = bool
  description = "Whether to retain the bucket and its contents when destroyed. The objects can be recovered."
}

variable "bucket_configuration" {
  type = object({
    binaries     = object({ name = string, expiration_days = number })
    deliveries   = object({ name = string, expiration_days = number })
    large_queue  = object({ name = string, expiration_days = number })
    metadata     = object({ name = string, expiration_days = number })
    modules      = object({ name = string, expiration_days = number })
    policy       = object({ name = string, expiration_days = number })
    run_logs     = object({ name = string, expiration_days = number })
    states       = object({ name = string, expiration_days = number })
    uploads      = object({ name = string, expiration_days = number })
    user_uploads = object({ name = string, expiration_days = number })
    workspace    = object({ name = string, expiration_days = number })
  })
}
