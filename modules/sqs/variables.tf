variable "kms_master_key_arn" {
  type        = string
  description = "ARN of the KMS master key to use for SQS queue encryption."
}

variable "mqtt_broker_type" {
  type        = string
  description = "The type of MQTT broker to use. Can be 'builtin' or 'iotcore'."
  default     = "builtin"
}

variable "region" {
  type        = string
  description = "AWS region, used for naming the IoT IAM role."
}
