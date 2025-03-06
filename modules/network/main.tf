locals {
  private_cidr_block = cidrsubnet(var.vpc_cidr_block, 2, 0)
  public_cidr_block  = cidrsubnet(var.vpc_cidr_block, 2, 1)
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "spacelift_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = false
  enable_dns_support   = true
}

resource "aws_subnet" "private_subnets" {
  count = 3

  vpc_id                  = aws_vpc.spacelift_vpc.id
  cidr_block              = cidrsubnet(local.private_cidr_block, 2, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
}

resource "aws_subnet" "public_subnets" {
  count = 3

  vpc_id                  = aws_vpc.spacelift_vpc.id
  cidr_block              = cidrsubnet(local.public_cidr_block, 2, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
}
