output "key_arn" {
  value       = aws_kms_key.kms_master_key.arn
  description = "The ARN of the KMS key"
}
