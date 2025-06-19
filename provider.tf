terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 7.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
