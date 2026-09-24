locals {
  database_name = "spacelift"

  # A global secondary always reads the primary's secret. Deciding that from
  # is_global_secondary keeps the data source's count known at plan time, even
  # when the primary's secret doesn't exist yet and its ARN is still unknown.
  read_credentials_from_sm = var.is_global_secondary ? true : var.password_sm_arn != null

  credentials_from_sm = !local.read_credentials_from_sm ? null : regex(
    "^postgres://([^:]+):([^@]+)@",
    jsondecode(data.aws_secretsmanager_secret_version.db_pw[0].secret_string)["DATABASE_URL"],
  )
  username = local.read_credentials_from_sm ? local.credentials_from_sm[0] : var.db_username
  password = local.read_credentials_from_sm ? local.credentials_from_sm[1] : random_id.db_pw.b64_url

  url_suffix                 = ":5432/${local.database_name}?statement_cache_capacity=0"
  database_url               = "postgres://${local.username}:${urlencode(local.password)}@${aws_rds_cluster.db_cluster.endpoint}${local.url_suffix}"
  database_read_only_url     = "postgres://${local.username}:${urlencode(local.password)}@${aws_rds_cluster.db_cluster.reader_endpoint}${local.url_suffix}"
  database_iam_url           = var.iam_username == null ? null : "postgres://${var.iam_username}@${aws_rds_cluster.db_cluster.endpoint}${local.url_suffix}"
  database_iam_read_only_url = var.iam_username == null ? null : "postgres://${var.iam_username}@${aws_rds_cluster.db_cluster.reader_endpoint}${local.url_suffix}"
}

data "aws_availability_zones" "available" {
  region = var.region
}

resource "random_id" "db_pw" {
  byte_length = 24
}

data "aws_secretsmanager_secret_version" "db_pw" {
  count = local.read_credentials_from_sm ? 1 : 0

  # The primary's secret lives in the primary's region, which the ARN tells us.
  region    = startswith(var.password_sm_arn, "arn:") ? split(":", var.password_sm_arn)[3] : var.region
  secret_id = var.password_sm_arn

  lifecycle {
    precondition {
      condition     = var.password_sm_arn != null
      error_message = "A global secondary needs password_sm_arn pointing at the primary's database secret."
    }
  }
}

resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier = coalesce(var.regional_cluster_identifier, "spacelift-${var.suffix}")

  # A global secondary inherits the database and the master credentials from
  # the primary cluster, so AWS rejects them on creation.
  database_name   = var.is_global_secondary ? null : local.database_name
  master_username = var.is_global_secondary ? null : local.username
  master_password = var.is_global_secondary ? null : local.password

  # When restoring from a snapshot, the master username comes from the snapshot
  # and must match var.db_username, otherwise the generated connection strings
  # won't work. The master password is reset to the generated one after restore.
  snapshot_identifier = var.snapshot_identifier

  region = var.region

  global_cluster_identifier     = var.global_cluster_identifier
  replication_source_identifier = var.replication_source_identifier

  engine                      = "aurora-postgresql"
  engine_mode                 = var.engine_mode
  engine_version              = var.postgres_engine_version
  allow_major_version_upgrade = true
  apply_immediately           = var.apply_immediately

  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.serverlessv2_scaling_configuration != null ? [1] : []
    content {
      max_capacity             = var.serverlessv2_scaling_configuration.max_capacity
      min_capacity             = var.serverlessv2_scaling_configuration.min_capacity
      seconds_until_auto_pause = var.serverlessv2_scaling_configuration.seconds_until_auto_pause
    }
  }

  availability_zones   = coalesce(var.availability_zones, slice(data.aws_availability_zones.available.names, 0, length(var.subnet_ids)))
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  kms_key_id        = var.kms_key_arn
  storage_encrypted = true

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = true

  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled          = lookup(var.performance_insights, "enabled", false)
  performance_insights_kms_key_id       = lookup(var.performance_insights, "kms_key_arn", null)
  performance_insights_retention_period = lookup(var.performance_insights, "retention_period", null)

  deletion_protection             = var.db_delete_protection_enabled
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.spacelift.name

  port                                = 5432
  vpc_security_group_ids              = var.security_group_ids
  iam_database_authentication_enabled = true
  enable_http_endpoint                = var.enable_http_endpoint

  # Attaching or detaching a running cluster from a global cluster is done
  # through the global cluster resource (or out of band), so we only take these
  # values into account on creation and ignore any drift afterwards.
  lifecycle {
    ignore_changes = [global_cluster_identifier, replication_source_identifier]

    precondition {
      condition     = !var.is_global_secondary || var.global_cluster_identifier != null
      error_message = "A global secondary needs global_cluster_identifier."
    }

    precondition {
      condition     = !var.is_global_secondary || (var.snapshot_identifier == null && var.replication_source_identifier == null)
      error_message = "A global secondary can't be restored from a snapshot or replicate from another cluster."
    }
  }
}

resource "aws_rds_cluster_instance" "db_instance" {
  for_each = var.instance_configuration

  region = var.region

  cluster_identifier                    = aws_rds_cluster.db_cluster.id
  identifier                            = each.value["instance_identifier"]
  instance_class                        = each.value["instance_class"]
  engine                                = aws_rds_cluster.db_cluster.engine
  auto_minor_version_upgrade            = false
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"
  performance_insights_enabled          = lookup(var.performance_insights, "enabled", false)
  performance_insights_kms_key_id       = lookup(var.performance_insights, "kms_key_arn", null)
  performance_insights_retention_period = lookup(var.performance_insights, "retention_period", null)
  monitoring_interval                   = var.monitoring.interval
  monitoring_role_arn                   = var.monitoring.role_arn
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = coalesce(var.subnet_group_name, "spacelift-${var.suffix}")
  description = "Joins the Spacelift database to the private subnets"
  subnet_ids  = var.subnet_ids

  region = var.region
}

resource "aws_rds_cluster_parameter_group" "spacelift" {
  name        = var.parameter_group_name
  name_prefix = var.parameter_group_name == null ? "spacelift-${var.suffix}" : null
  description = coalesce(var.parameter_group_description, "Spacelift core product database parameter group.")
  family      = join("", ["aurora-postgresql", substr(var.postgres_engine_version, 0, 2)])

  region = var.region

  lifecycle {
    create_before_destroy = true
  }

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

  region = var.region
}

resource "aws_secretsmanager_secret_version" "conn_string" {
  secret_id = aws_secretsmanager_secret.conn_string.id
  secret_string = jsonencode(merge({
    DATABASE_URL           = local.database_url
    DATABASE_READ_ONLY_URL = local.database_read_only_url
    },
    var.iam_username == null ? {} : {
      DATABASE_IAM_URL           = local.database_iam_url
      DATABASE_IAM_READ_ONLY_URL = local.database_iam_read_only_url
  }))

  region = var.region
}
