resource "random_uuid" "suffix" {
}

data "aws_rds_engine_version" "pgversion" {
  region = var.primary_region
  engine = "aurora-postgresql"
  latest = true
}

resource "aws_rds_global_cluster" "spacelift" {
  region = var.primary_region

  global_cluster_identifier = "spacelift-global-${lower(substr(random_uuid.suffix.id, 0, 5))}"
  engine                    = "aurora-postgresql"
  engine_version            = data.aws_rds_engine_version.pgversion.version_actual
  storage_encrypted         = true
}

module "primary" {
  source = "../../"

  region = var.primary_region

  rds_engine_version            = data.aws_rds_engine_version.pgversion.version_actual
  rds_global_cluster_identifier = aws_rds_global_cluster.spacelift.id
  website_endpoint              = "https://spacelift.example.com"

  rds_delete_protection_enabled = false
  s3_retain_on_destroy          = false
  ecr_force_delete              = true
}

module "secondary" {
  source = "../../"

  region = var.secondary_region

  rds_engine_version            = data.aws_rds_engine_version.pgversion.version_actual
  rds_global_cluster_identifier = aws_rds_global_cluster.spacelift.id
  website_endpoint              = "https://spacelift.example.com"

  # The secondary inherits the master credentials from the primary, and reads
  # them from the primary's database secret to build its own connection strings.
  # This also makes Terraform create the secondary after the primary and
  # destroy it before, which is the order the global cluster needs.
  rds_is_global_secondary = true
  rds_password_sm_arn     = module.primary.database_secret_arn

  rds_delete_protection_enabled = false
  s3_retain_on_destroy          = false
  ecr_force_delete              = true
}

output "primary_shell" {
  value = module.primary.shell
}

output "primary_tfvars" {
  sensitive = true
  value     = module.primary.tfvars
}

output "secondary_shell" {
  value = module.secondary.shell
}

output "secondary_tfvars" {
  sensitive = true
  value     = module.secondary.tfvars
}
