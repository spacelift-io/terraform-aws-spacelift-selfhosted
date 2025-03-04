variable "suffix" {
  type        = string
  description = "Unique postfix for resource names."
}

variable "encryption_key_arn" {
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
