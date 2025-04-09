variable "region" {
  type        = string
  description = "AWS region to deploy resources in."
}

variable "account_id" {
  type        = string
  description = "AWS account ID."
}

variable "master_key_multi_regional" {
  type        = bool
  description = "Whether the master key should be multi-regional."
}

variable "encryption_key_multi_regional" {
  type        = bool
  description = "Whether the encryption key should be multi-regional."
}

variable "jwt_key_multi_regional" {
  type        = bool
  description = "Whether the JWT key should be multi-regional."
}
