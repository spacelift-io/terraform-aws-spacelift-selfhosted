module "spacelift" {
  source = "../../"

  region = var.aws_region

  # No ECR repositories: the images come from another registry,
  # such as registry.spacelift.io.
  create_container_registry = false

  rds_engine_version   = null
  create_vpc           = false
  create_database      = false
  website_endpoint     = "https://spacelift.example.com"
  s3_retain_on_destroy = false
}
