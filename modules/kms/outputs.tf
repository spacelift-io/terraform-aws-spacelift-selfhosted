output "key_arn" {
  value       = one(aws_kms_key.deploy_kms_master_key[*].arn)
  description = "The ARN of the KMS key, used for encrypting AWS resources"
}

output "encryption_key_arn" {
  value       = one(aws_kms_key.deploy_encryption_key[*].arn)
  description = "The ARN of the KMS key, used for in-app encryption"
}

output "jwt_key_arn" {
  value       = one(aws_kms_key.deploy_jwt_key[*].arn)
  description = "The ARN of the KMS key, used for signing and verifying JWTs"
}

output "flows_key_arn" {
  value       = one(aws_kms_key.flows_kms_key[*].arn)
  description = "The ARN of the KMS key, used for encrypting the Spacelift Flows bucket."
}
