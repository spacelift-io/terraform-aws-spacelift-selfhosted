terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      "module"  = "terraform-aws-spacelift-selfhosted"
      "example" = "custom-vpc"
    }
  }
}
