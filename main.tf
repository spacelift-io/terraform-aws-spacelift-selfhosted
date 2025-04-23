data "aws_caller_identity" "current" {}

resource "random_uuid" "suffix" {
}

locals {
  suffix                 = coalesce(lower(var.unique_suffix), lower(substr(random_uuid.suffix.id, 0, 5))) # Certain resources (subnet group, rds) require all lowercase names
  uploads_bucket_url     = "https://${module.s3.uploads_bucket_name}.s3.${var.region}.${data.aws_partition.current.dns_suffix}"
  database_url           = var.create_database ? format("postgres://%s:%s@%s:5432/spacelift?statement_cache_capacity=0", var.rds_username, urlencode(module.rds[0].db_password), module.rds[0].cluster_endpoint) : ""
  database_read_only_url = var.create_database ? format("postgres://%s:%s@%s:5432/spacelift?statement_cache_capacity=0", var.rds_username, urlencode(module.rds[0].db_password), module.rds[0].reader_endpoint) : ""
  kms_arn                = var.kms_arn != null && var.kms_arn != "" ? var.kms_arn : module.kms[0].key_arn
}

module "kms" {
  source = "./modules/kms"
  count  = var.kms_arn == null ? 1 : 0

  region                        = var.region
  account_id                    = data.aws_caller_identity.current.account_id
  master_key_multi_regional     = var.kms_master_key_multi_regional
  encryption_key_multi_regional = var.kms_encryption_key_multi_regional
  jwt_key_multi_regional        = var.kms_jwt_key_multi_regional
}

module "ecr" {
  source = "./modules/ecr"

  kms_key_arn                = local.kms_arn
  suffix                     = local.suffix
  number_of_images_to_retain = var.number_of_images_to_retain
  ecr_force_delete           = var.ecr_force_delete
  backend_repository_name    = var.backend_ecr_repository_name
  launcher_repository_name   = var.launcher_ecr_repository_name
}

module "network" {
  source = "./modules/network"
  count  = var.create_vpc ? 1 : 0

  suffix                     = local.suffix
  create_database            = var.create_database
  vpc_cidr_block             = var.vpc_cidr_block
  enable_dns_hostnames       = var.enable_dns_hostnames
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  public_subnet_tags         = var.public_subnet_tags
  private_subnet_tags        = var.private_subnet_tags
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  security_group_names       = var.security_group_names
}

module "rds" {
  source = "./modules/rds"
  count  = var.create_database ? 1 : 0

  suffix = local.suffix

  postgres_engine_version            = var.rds_engine_version
  engine_mode                        = var.rds_engine_mode
  serverlessv2_scaling_configuration = var.rds_serverlessv2_scaling_configuration

  parameter_group_name        = var.rds_parameter_group_name
  parameter_group_description = var.rds_parameter_group_description
  subnet_group_name           = var.rds_subnet_group_name
  regional_cluster_identifier = var.rds_regional_cluster_identifier

  db_username     = var.rds_username
  password_sm_arn = var.rds_password_sm_arn

  instance_configuration = var.rds_instance_configuration

  db_delete_protection_enabled = var.rds_delete_protection_enabled
  backup_retention_period      = var.rds_backup_retention_period
  preferred_backup_window      = var.rds_preferred_backup_window

  subnet_ids         = length(coalesce(var.rds_subnet_ids, [])) > 0 ? var.rds_subnet_ids : values(module.network[0].private_subnet_ids)
  security_group_ids = length(coalesce(var.rds_security_group_ids, [])) > 0 ? var.rds_security_group_ids : [module.network[0].database_security_group_id]

  kms_key_arn = local.kms_arn
}

module "s3" {
  source = "./modules/s3"

  suffix = local.suffix

  bucket_names       = var.s3_bucket_names
  kms_master_key_arn = local.kms_arn
  cors_hostname      = var.website_endpoint
  retain_on_destroy  = var.s3_retain_on_destroy
}
