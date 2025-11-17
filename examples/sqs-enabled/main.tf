module "spacelift" {
  source = "../../"

  region = var.aws_region

  create_vpc           = false
  create_database      = false
  website_endpoint     = "https://spacelift.example.com"
  create_sqs           = true
  s3_retain_on_destroy = false
  ecr_force_delete     = true
}
