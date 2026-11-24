data "aws_rds_engine_version" "pgversion" {
  engine = "aurora-postgresql"
  latest = true
}

module "spacelift" {
  source = "../../"

  region = "us-east-1"

  rds_engine_version = data.aws_rds_engine_version.pgversion.version_actual
  website_endpoint   = "https://spacelift.example.com"

  # The images are pulled from another registry, such as oci.spacelift.io.
  create_container_registry = false
}
