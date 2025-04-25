locals {
  database_name       = "spacelift"
  db_url_from_sm      = var.password_sm_arn != null ? jsondecode(data.aws_secretsmanager_secret_version.db_pw[0].secret_string)["DATABASE_URL"] : ""
  db_password_from_sm = var.password_sm_arn != null ? regex("postgres://spacelift:([^@]+)@", local.db_url_from_sm)[0] : ""
  password            = var.password_sm_arn != null ? local.db_password_from_sm : random_id.db_pw.b64_url
}

data "aws_availability_zones" "available" {}

resource "random_id" "db_pw" {
  byte_length = 24
}

data "aws_secretsmanager_secret_version" "db_pw" {
  count = var.password_sm_arn != null ? 1 : 0

  secret_id = var.password_sm_arn
}

resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier = coalesce(var.regional_cluster_identifier, "spacelift-${var.suffix}")
  database_name      = local.database_name

  engine      = "aurora-postgresql"
  engine_mode = var.engine_mode

  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.serverlessv2_scaling_configuration != null ? [1] : []
    content {
      max_capacity             = var.serverlessv2_scaling_configuration.max_capacity
      min_capacity             = var.serverlessv2_scaling_configuration.min_capacity
      seconds_until_auto_pause = var.serverlessv2_scaling_configuration.seconds_until_auto_pause
    }
  }

  availability_zones   = slice(data.aws_availability_zones.available.names, 0, length(var.subnet_ids))
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  kms_key_id        = var.kms_key_arn
  storage_encrypted = true
  master_username   = var.db_username
  master_password   = local.password

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = true

  deletion_protection             = var.db_delete_protection_enabled
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.spacelift.name

  port                                = 5432
  vpc_security_group_ids              = var.security_group_ids
  iam_database_authentication_enabled = true
}

resource "aws_rds_cluster_instance" "db_instance" {
  for_each = var.instance_configuration

  cluster_identifier         = aws_rds_cluster.db_cluster.id
  identifier                 = each.value["instance_identifier"]
  instance_class             = each.value["instance_class"]
  engine                     = aws_rds_cluster.db_cluster.engine
  auto_minor_version_upgrade = false
  ca_cert_identifier         = "rds-ca-rsa2048-g1"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = coalesce(var.subnet_group_name, "spacelift-${var.suffix}")
  description = "Joins the Spacelift database to the private subnets"
  subnet_ids  = var.subnet_ids
}

resource "aws_rds_cluster_parameter_group" "spacelift" {
  name        = coalesce(var.parameter_group_name, "spacelift-${var.suffix}")
  description = coalesce(var.parameter_group_description, "Spacelift core product database parameter group.")
  family      = join("", ["aurora-postgresql", substr(var.postgres_engine_version, 0, 2)])

  parameter {
    apply_method = "immediate"
    name         = "statement_timeout"
    value        = "120000"
  }
}

resource "aws_secretsmanager_secret" "conn_string" {
  name                    = "spacelift/db-conn-string-${var.suffix}"
  description             = "Spacelift database connection string"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "conn_string" {
  secret_id = aws_secretsmanager_secret.conn_string.id
  secret_string = jsonencode({
    DATABASE_URL           = "postgres://${var.db_username}:${local.password}@${aws_rds_cluster.db_cluster.endpoint}:5432/${local.database_name}?statement_cache_capacity=0"
    DATABASE_READ_ONLY_URL = "postgres://${var.db_username}:${local.password}@${aws_rds_cluster.db_cluster.reader_endpoint}:5432/${local.database_name}?statement_cache_capacity=0"
  })
}
