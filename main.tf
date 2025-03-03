data "aws_caller_identity" "current" {}

resource "random_id" "seed" {
  byte_length = 6
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
  seed                       = random_id.seed.id
  number_of_images_to_retain = var.number_of_images_to_retain
}

module "network" {
  source = "./modules/network"
  count  = var.create_vpc ? 1 : 0

  vpc_cidr_block   = var.vpc_cidr_block
  subnet_mask_size = var.subnet_mask_size
}

module "rds" {
  source = "./modules/rds"
  count  = var.create_database ? 1 : 0

  seed = random_id.seed.id

  postgres_engine_version = var.rds_engine_version
  engine_mode             = var.rds_engine_mode

  db_username = var.rds_username

  instance_configuration = var.rds_instance_configuration

  db_delete_protection_enabled = var.rds_delete_protection_enabled

  subnet_ids         = coalescelist(var.rds_subnet_ids, module.network[0].private_subnet_ids)
  security_group_ids = coalescelist(var.rds_security_group_ids, [module.network[0].database_security_group_id])

  kms_key_arn = coalesce(var.kms_arn, module.kms[0].key_arn)
}

