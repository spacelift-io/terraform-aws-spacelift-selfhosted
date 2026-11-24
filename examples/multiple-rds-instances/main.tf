data "aws_rds_engine_version" "pgversion" {
  engine = "aurora-postgresql"
  latest = true
}

module "spacelift" {
  source = "../../"

  region = "us-east-1"

  rds_engine_version = data.aws_rds_engine_version.pgversion.version_actual
  website_endpoint   = "https://spacelift.example.com"

  rds_instance_configuration = {
    "primary-instance" = {
      instance_identifier = "primary"
      instance_class      = "db.r6g.large"
    }
    "secondary-instance" = {
      instance_identifier = "secondary"
      instance_class      = "db.r6g.large"
    }
  }
}
