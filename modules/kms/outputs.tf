output "key_arn" {
  value       = aws_kms_key.kms_master_key.arn
  description = "The ARN of the KMS key, used for encrypting AWS resources"
}

output "encryption_key_arn" {
  value       = aws_kms_key.encryption_key.arn
  description = "The ARN of the KMS key, used for in-app encryption"
}
