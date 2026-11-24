data "aws_rds_engine_version" "pgversion" {
  engine = "aurora-postgresql"
  latest = true
}

module "spacelift" {
  source = "../../"

  region = "us-east-1"

  rds_engine_version = data.aws_rds_engine_version.pgversion.version_actual
  website_endpoint   = "https://spacelift.example.com"

  # A Postgres user you create yourself for IAM authentication, see the README.
  rds_iam_username = "spacelift_iam"
}
