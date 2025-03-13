data "aws_caller_identity" "current" {}

resource "random_uuid" "suffix" {
}

locals {
  suffix             = coalesce(lower(var.unique_suffix), lower(substr(random_uuid.suffix.id, 0, 5))) # Certain resources (subnet group, rds) require all lowercase names
  uploads_bucket_url = "https://${module.s3.uploads_bucket_name}.s3.${var.region}.${data.aws_partition.current.dns_suffix}"
}

module "kms" {
  source = "./modules/kms"
  count  = var.kms_arn == null ? 1 : 0

  region     = var.region
  account_id = data.aws_caller_identity.current.account_id
}

module "ecr" {
  source = "./modules/ecr"

  kms_key_arn                = coalesce(var.kms_arn, module.kms[0].key_arn)
  suffix                     = local.suffix
  number_of_images_to_retain = var.number_of_images_to_retain
}

module "network" {
  source = "./modules/network"
  count  = var.create_vpc ? 1 : 0

  suffix          = local.suffix
  create_database = var.create_database
  vpc_cidr_block  = var.vpc_cidr_block
}

module "rds" {
  source = "./modules/rds"
  count  = var.create_database ? 1 : 0

  suffix = local.suffix

  postgres_engine_version            = var.rds_engine_version
  engine_mode                        = var.rds_engine_mode
  serverlessv2_scaling_configuration = var.rds_serverlessv2_scaling_configuration

  db_username = var.rds_username

  instance_configuration = var.rds_instance_configuration

  db_delete_protection_enabled = var.rds_delete_protection_enabled
  backup_retention_period      = var.rds_backup_retention_period
  preferred_backup_window      = var.rds_preferred_backup_window

  subnet_ids         = coalescelist(var.rds_subnet_ids, values(module.network[0].private_subnet_ids))
  security_group_ids = coalescelist(var.rds_security_group_ids, [module.network[0].database_security_group_id])

  kms_key_arn = coalesce(var.kms_arn, module.kms[0].key_arn)
}

module "s3" {
  source = "./modules/s3"

  suffix = local.suffix

  encryption_key_arn = coalesce(var.kms_arn, module.kms[0].key_arn)
  cors_hostname      = var.website_endpoint
  retain_on_destroy  = var.s3_retain_on_destroy
}
