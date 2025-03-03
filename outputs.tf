output "kms_key_arn" {
  value       = coalesce(var.kms_arn, module.kms[0].key_arn)
  description = "ARN of the KMS key used for encryption."
}

output "server_security_group_id" {
  value = var.create_vpc ? module.network[0].server_security_group_id : null
}

output "drain_security_group_id" {
  value = var.create_vpc ? module.network[0].drain_security_group_id : null
}

output "private_subnet_ids" {
  value = var.create_vpc ? module.network[0].private_subnet_ids : null
}

output "rds_global_cluster_id" {
  description = "ID of the global Aurora cluster."
  value       = var.create_database ? module.rds[0].database_global_aurora_identifier : null
}

output "rds_iam_auth_arn" {
  description = "Authentication ARN for the RDS database"
  value       = var.create_database ? "arn:aws:rds-db:${var.region}:${data.aws_caller_identity.current.account_id}:dbuser:${module.rds[0].cluster_resource_id}" : null
}

output "rds_username" {
  description = "Username for the RDS database. Not supposed to be used, the application should use IAM authentication."
  value       = var.rds_username
}

output "rds_password" {
  description = "Password for the RDS database. Not supposed to be used, the application should use IAM authentication."
  value       = var.create_database ? module.rds[0].db_password : null
  sensitive   = true
}

output "ecr_backend_repository_url" {
  value       = module.ecr.ecr_backend_repository_url
  description = "URL of the ECR repository for the backend images."
}

output "ecr_launcher_repository_url" {
  value       = module.ecr.ecr_launcher_repository_url
  description = "URL of the ECR repository for the launcher images."
}
