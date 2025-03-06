output "unique_suffix" {
  value       = local.suffix
  description = "Randomly generated suffix for AWS resource names, ensuring uniqueness."
}

output "kms_key_arn" {
  value       = length(module.kms) > 0 ? module.kms[0].key_arn : null
  description = "ARN of the KMS key used for encrypting AWS resources."
}

output "encryption_key_arn" {
  value       = length(module.kms) > 0 ? module.kms[0].encryption_key_arn : null
  description = "ARN of the KMS key used for in-app encryption."
}

output "server_security_group_id" {
  value       = var.create_vpc ? module.network[0].server_security_group_id : null
  description = "ID of the security group for the Spacelift HTTP server. It will be null if create_vpc is false."
}

output "drain_security_group_id" {
  value       = var.create_vpc ? module.network[0].drain_security_group_id : null
  description = "ID of the security group for the Spacelift async-processing service. It will be null if create_vpc is false."
}

output "scheduler_security_group_id" {
  value       = var.create_vpc ? module.network[0].scheduler_security_group_id : null
  description = "ID of the security group for the Spacelift scheduler service. It will be null if create_vpc is false."
}

output "database_security_group_id" {
  value       = var.create_vpc ? module.network[0].database_security_group_id : null
  description = "ID of the security group for the Spacelift database. It will be null if create_database is false."
}

output "private_subnet_ids" {
  value       = var.create_vpc ? values(module.network[0].private_subnet_ids) : null
  description = "IDs of the private subnets. They will be null if create_vpc is false."
}

output "public_subnet_ids" {
  value       = var.create_vpc ? values(module.network[0].public_subnet_ids) : null
  description = "IDs of the public subnets. They will be null if create_vpc is false."
}

output "availability_zones" {
  value       = var.create_vpc ? keys(module.network[0].private_subnet_ids) : null
  description = "Availability zones of the private subnets. They will be null if create_vpc is false."
}

output "vpc_id" {
  value       = var.create_vpc ? module.network[0].vpc_id : null
  description = "ID of the VPC. It will be null if create_vpc is false."
}

output "rds_global_cluster_id" {
  description = "ID of the global Aurora cluster. Will be null if create_database is false."
  value       = var.create_database ? module.rds[0].database_global_aurora_identifier : null
}

output "rds_cluster_endpoint" {
  description = "Endpoint of the RDS cluster. Will be null if create_database is false."
  value       = var.create_database ? module.rds[0].cluster_endpoint : null
}

output "rds_cluster_reader_endpoint" {
  description = "Reader endpoint of the RDS cluster. Will be null if create_database is false."
  value       = var.create_database ? module.rds[0].reader_endpoint : null
}

output "rds_username" {
  description = "Username for the RDS database."
  value       = var.rds_username
}

output "rds_password" {
  description = "Password for the RDS database. Will be null if create_database is false."
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

output "deliveries_bucket_arn" {
  value       = module.s3.deliveries_bucket_arn
  description = "ARN of the S3 bucket used for storing deliveries."
}

output "deliveries_bucket_name" {
  value       = module.s3.deliveries_bucket_name
  description = "ID of the S3 bucket used for storing deliveries."
}

output "large_queue_messages_bucket_arn" {
  value       = module.s3.large_queue_messages_bucket_arn
  description = "ARN of the S3 bucket used for storing large queue messages."
}

output "large_queue_messages_bucket_name" {
  value       = module.s3.large_queue_messages_bucket_name
  description = "ID of the S3 bucket used for storing large queue messages."
}

output "metadata_bucket_arn" {
  value       = module.s3.metadata_bucket_arn
  description = "ARN of the S3 bucket used for storing metadata."
}

output "metadata_bucket_name" {
  value       = module.s3.metadata_bucket_name
  description = "ID of the S3 bucket used for storing metadata."
}

output "modules_bucket_arn" {
  value       = module.s3.modules_bucket_arn
  description = "ARN of the S3 bucket used for storing modules."
}

output "modules_bucket_name" {
  value       = module.s3.modules_bucket_name
  description = "ID of the S3 bucket used for storing modules."
}

output "policy_inputs_bucket_arn" {
  value       = module.s3.policy_inputs_bucket_arn
  description = "ARN of the S3 bucket used for storing policy inputs."
}

output "policy_inputs_bucket_name" {
  value       = module.s3.policy_inputs_bucket_name
  description = "ID of the S3 bucket used for storing policy inputs."
}

output "run_logs_bucket_arn" {
  value       = module.s3.run_logs_bucket_arn
  description = "ARN of the S3 bucket used for storing run logs."
}

output "run_logs_bucket_name" {
  value       = module.s3.run_logs_bucket_name
  description = "ID of the S3 bucket used for storing run logs."
}

output "states_bucket_arn" {
  value       = module.s3.states_bucket_arn
  description = "ARN of the S3 bucket used for storing states."
}

output "states_bucket_name" {
  value       = module.s3.states_bucket_name
  description = "ID of the S3 bucket used for storing states."
}

output "uploads_bucket_arn" {
  value       = module.s3.uploads_bucket_arn
  description = "ARN of the S3 bucket used for storing uploads."
}

output "uploads_bucket_name" {
  value       = module.s3.uploads_bucket_name
  description = "ID of the S3 bucket used for storing uploads."
}

data "aws_partition" "current" {}

output "uploads_bucket_url" {
  value       = "https://${module.s3.uploads_bucket_name}.s3.${var.region}.${data.aws_partition.current.dns_suffix}"
  description = "URL of the S3 bucket used for storing uploads."
}

output "user_uploaded_workspaces_arn" {
  value       = module.s3.user_uploaded_workspaces_arn
  description = "ARN of the S3 bucket used for storing user uploaded workspaces."
}

output "user_uploaded_workspaces_bucket_name" {
  value       = module.s3.user_uploaded_workspaces_bucket_name
  description = "ID of the S3 bucket used for storing user uploaded workspaces."
}

output "workspace_bucket_arn" {
  value       = module.s3.workspace_bucket_arn
  description = "ARN of the S3 bucket used for storing workspaces."
}

output "workspace_bucket_name" {
  value       = module.s3.workspace_bucket_name
  description = "ID of the S3 bucket used for storing workspaces."
}
