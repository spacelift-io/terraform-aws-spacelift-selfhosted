variable "suffix" {
  type        = string
  description = "Unique postfix for resource names."
}

variable "number_of_images_to_retain" {
  type        = number
  description = "Number of images to retain in the ECR repository."
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key to use for encrypting the ECR repository."
}
