resource "random_uuid" "suffix" {
}

module "network" {
  source = "../../modules/network"

  suffix               = lower(substr(random_uuid.suffix.id, 0, 5))
  create_database      = true
  vpc_cidr_block       = "10.0.0.0/18"
  enable_dns_hostnames = false

  private_subnet_tags = {
    "subnet-role" = "private"
  }

  public_subnet_tags = {
    "subnet-role" = "public"
  }

  private_subnet_cidr_blocks = []
  public_subnet_cidr_blocks  = []
  security_group_names       = null
}

module "spacelift" {
  source = "../../"

  region = var.aws_region

  create_vpc             = false
  rds_subnet_ids         = values(module.network.private_subnet_ids)
  rds_security_group_ids = [module.network.database_security_group_id]
  website_endpoint       = "https://spacelift.example.com"

  rds_delete_protection_enabled = false
  s3_retain_on_destroy          = false
  ecr_force_delete              = true
}

output "shell" {
  value = module.spacelift.shell
}

output "tfvars" {
  sensitive = true
  value     = module.spacelift.tfvars
}
