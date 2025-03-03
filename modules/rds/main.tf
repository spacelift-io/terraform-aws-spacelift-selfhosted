locals {
  database_name = "spacelift"
}

data "aws_availability_zones" "available" {}

resource "random_password" "db_pw" {
  length  = 16
  special = true
}

resource "aws_rds_global_cluster" "global_cluster" {
  global_cluster_identifier = "spacelift-global-cluster-${var.seed}"
  engine                    = "aurora-postgresql"
  engine_version            = var.postgres_engine_version
  deletion_protection       = var.db_delete_protection_enabled
  database_name             = local.database_name
}

resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier = "spacelift-${var.seed}"
  database_name      = local.database_name

  engine      = aws_rds_global_cluster.global_cluster.engine
  engine_mode = var.engine_mode

  availability_zones   = slice(data.aws_availability_zones.available.names, 0, length(var.subnet_ids))
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  kms_key_id        = var.kms_key_arn
  storage_encrypted = true
  master_username   = var.db_username
  master_password   = random_password.db_pw.result

  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  copy_tags_to_snapshot   = true

  deletion_protection             = var.db_delete_protection_enabled
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.spacelift.name

  port                                = 5432
  vpc_security_group_ids              = var.security_group_ids
  iam_database_authentication_enabled = true
}

resource "aws_rds_cluster_instance" "db_instance" {
  for_each = var.instance_configuration

  cluster_identifier         = each.value["instance_identifier"]
  instance_class             = each.value["instance_class"]
  engine                     = aws_rds_global_cluster.global_cluster.engine
  auto_minor_version_upgrade = false
  ca_cert_identifier         = "rds-ca-rsa2048-g1"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "spacelift-${var.seed}"
  description = "Joins the Spacelift database to the private subnets"
  subnet_ids  = var.subnet_ids
}

resource "aws_rds_cluster_parameter_group" "spacelift" {
  name        = "spacelift-${var.seed}"
  description = "Spacelift core product database parameter group."
  family      = join("", ["aurora-postgresql", substr(var.postgres_engine_version, 0, 2)])

  parameter {
    apply_method = "immediate"
    name         = "statement_timeout"
    value        = "120000"
  }
}
