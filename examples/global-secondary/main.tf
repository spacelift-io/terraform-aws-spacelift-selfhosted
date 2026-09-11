provider "aws" {
  region = var.primary_region
}

resource "aws_rds_global_cluster" "spacelift" {
  region = var.primary_region

  global_cluster_identifier = "spacelift-global"
  engine                    = "aurora-postgresql"
  engine_version            = var.rds_engine_version
  database_name             = "spacelift"
}

module "primary" {
  source = "../.."

  region             = var.primary_region
  website_endpoint   = var.website_endpoint
  unique_suffix      = "primary"
  rds_engine_version = var.rds_engine_version
  kms_arn            = var.primary_kms_key_arn

  rds_global_cluster_identifier = aws_rds_global_cluster.spacelift.id

  vpc_cidr_block = "10.10.0.0/18"
  public_subnet_cidr_blocks = [
    "10.10.0.0/24",
    "10.10.1.0/24",
    "10.10.2.0/24",
  ]
  private_subnet_cidr_blocks = [
    "10.10.16.0/20",
    "10.10.32.0/20",
    "10.10.48.0/20",
  ]
}

module "secondary" {
  source = "../.."

  region             = var.secondary_region
  website_endpoint   = var.website_endpoint
  unique_suffix      = "secondary"
  rds_engine_version = var.rds_engine_version
  kms_arn            = var.secondary_kms_key_arn

  rds_global_cluster_identifier = aws_rds_global_cluster.spacelift.id
  rds_global_cluster_role       = "secondary"

  # Reuse the credentials inherited from the primary cluster.
  rds_password_sm_arn    = module.primary.database_secret_arn
  rds_password_sm_region = var.primary_region

  rds_instance_configuration = {
    secondary = {
      instance_identifier = "spacelift-secondary-1"
      instance_class      = "db.serverless"
    }
  }

  rds_serverlessv2_scaling_configuration = {
    min_capacity = 0
    max_capacity = 8
  }

  vpc_cidr_block = "10.20.0.0/18"
  public_subnet_cidr_blocks = [
    "10.20.0.0/24",
    "10.20.1.0/24",
    "10.20.2.0/24",
  ]
  private_subnet_cidr_blocks = [
    "10.20.16.0/20",
    "10.20.32.0/20",
    "10.20.48.0/20",
  ]

  # Keep this until the primary secret ARN output depends on its secret version.
  depends_on = [module.primary]
}
