terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Every resource in the module takes its region explicitly, so one provider
# covers both regions.
provider "aws" {
  region = var.primary_region

  default_tags {
    tags = {
      "module"  = "terraform-aws-spacelift-selfhosted"
      "example" = "global-database"
    }
  }
}
