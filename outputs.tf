output "unique_suffix" {
  value       = local.suffix
  description = "Randomly generated suffix for AWS resource names, ensuring uniqueness."
}

output "kms_key_arn" {
  value       = length(module.kms) > 0 ? module.kms[0].key_arn : null
  description = "ARN of the KMS key used for encrypting AWS resources. Null if create_kms is false."
}

output "encryption_key_arn" {
  value       = length(module.kms) > 0 ? module.kms[0].encryption_key_arn : null
  description = "ARN of the KMS key used for in-app encryption. Null if create_kms is false."
}

output "jwt_signing_key_arn" {
  value       = length(module.kms) > 0 ? module.kms[0].jwt_key_arn : null
  description = "ARN of the KMS key used for signing and verifying JWTs. Null if create_kms is false."
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

output "ecr_backend_repository_arn" {
  value       = module.ecr.ecr_backend_repository_arn
  description = "ARN of the ECR repository for the backend images."
}

output "ecr_launcher_repository_url" {
  value       = module.ecr.ecr_launcher_repository_url
  description = "URL of the ECR repository for the launcher images."
}

output "ecr_launcher_repository_arn" {
  value       = module.ecr.ecr_launcher_repository_arn
  description = "ARN of the ECR repository for the launcher images."
}

output "binaries_bucket_arn" {
  value       = module.s3.binaries_bucket_arn
  description = "ARN of the S3 bucket used for storing binaries."
}

output "binaries_bucket_name" {
  value       = module.s3.binaries_bucket_name
  description = "ID of the S3 bucket used for storing binaries."
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
  value       = local.uploads_bucket_url
  description = "URL of the S3 bucket used for storing uploads."
}

output "user_uploaded_workspaces_bucket_arn" {
  value       = module.s3.user_uploaded_workspaces_bucket_arn
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

output "shell" {
  value = templatefile("${path.module}/env.tftpl", {
    env : {
      AWS_REGION : var.region
      AWS_ACCOUNT_ID : data.aws_caller_identity.current.account_id
      BACKEND_IMAGE : module.ecr.ecr_backend_repository_url
      LAUNCHER_IMAGE : module.ecr.ecr_launcher_repository_url
      PRIVATE_ECR_LOGIN_URL : split("/", module.ecr.ecr_backend_repository_url)[0]
      BINARIES_BUCKET_NAME : module.s3.binaries_bucket_name
    },
  })
}

output "tfvars" {
  sensitive = true
  value = templatefile("${path.module}/tfvars.tftpl", {
    stringVars : {
      aws_region : var.region
      unique_suffix : local.suffix
      vpc_id : var.create_vpc ? module.network[0].vpc_id : null
      server_security_group_id : var.create_vpc ? module.network[0].server_security_group_id : null
      drain_security_group_id : var.create_vpc ? module.network[0].drain_security_group_id : null
      scheduler_security_group_id : var.create_vpc ? module.network[0].scheduler_security_group_id : null
      backend_image : module.ecr.ecr_backend_repository_url
      launcher_image : module.ecr.ecr_launcher_repository_url
      database_url : var.create_database ? format("postgres://%s:%s@%s:5432/spacelift?statement_cache_capacity=0", var.rds_username, urlencode(module.rds[0].db_password), module.rds[0].cluster_endpoint) : null
      database_read_only_url : var.create_database ? format("postgres://%s:%s@%s:5432/spacelift?statement_cache_capacity=0", var.rds_username, urlencode(module.rds[0].db_password), module.rds[0].reader_endpoint) : null
      binaries_bucket_name : module.s3.binaries_bucket_name
      deliveries_bucket_name : module.s3.deliveries_bucket_name
      large_queue_messages_bucket_name : module.s3.large_queue_messages_bucket_name
      metadata_bucket_name : module.s3.metadata_bucket_name
      modules_bucket_name : module.s3.modules_bucket_name
      policy_inputs_bucket_name : module.s3.policy_inputs_bucket_name
      run_logs_bucket_name : module.s3.run_logs_bucket_name
      states_bucket_name : module.s3.states_bucket_name
      uploads_bucket_name : module.s3.uploads_bucket_name
      uploads_bucket_url : local.uploads_bucket_url
      user_uploaded_workspaces_bucket_name : module.s3.user_uploaded_workspaces_bucket_name
      workspace_bucket_name : module.s3.workspace_bucket_name
      encryption_key_arn : length(module.kms) > 0 ? module.kms[0].encryption_key_arn : null
      jwt_signing_key_arn : length(module.kms) > 0 ? module.kms[0].jwt_key_arn : null
      kms_key_arn : length(module.kms) > 0 ? module.kms[0].key_arn : null
    },
    jsonVars : {
      public_subnet_ids : var.create_vpc ? jsonencode(values(module.network[0].public_subnet_ids)) : null
      private_subnet_ids : var.create_vpc ? jsonencode(values(module.network[0].private_subnet_ids)) : null
      availability_zones : var.create_vpc ? jsonencode(keys(module.network[0].private_subnet_ids)) : null
    }
  })
}
