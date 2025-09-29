module "spacelift" {
  source = "../../"

  region = var.aws_region

  create_vpc       = false
  create_database  = false
  website_endpoint = "https://spacelift.example.com"

  # Setting the run logs expiration to 360 days
  s3_bucket_configuration = {
    run_logs = {
      name            = null
      expiration_days = 360
    }
    binaries     = null
    deliveries   = null
    large_queue  = null
    metadata     = null
    modules      = null
    policy       = null
    states       = null
    uploads      = null
    user_uploads = null
    workspace    = null
  }

  s3_retain_on_destroy = false
  ecr_force_delete     = true
}
