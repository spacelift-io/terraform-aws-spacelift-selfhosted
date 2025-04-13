locals {
  private_cidr_block = cidrsubnet(var.vpc_cidr_block, 2, 0)
  public_cidr_block  = cidrsubnet(var.vpc_cidr_block, 2, 1)
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "spacelift_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = true

  tags = {
    Name = "Spacelift VPC (${var.suffix})"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidr_blocks) > 0 ? length(var.private_subnet_cidr_blocks) : 3

  vpc_id                  = aws_vpc.spacelift_vpc.id
  cidr_block              = length(var.private_subnet_cidr_blocks) > 0 ? var.private_subnet_cidr_blocks[count.index] : cidrsubnet(local.private_cidr_block, 2, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(var.private_subnet_tags, {
    Name = "Spacelift Private Subnet (${var.suffix} - ${count.index})"
  })
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr_blocks) > 0 ? length(var.public_subnet_cidr_blocks) : 3

  vpc_id                  = aws_vpc.spacelift_vpc.id
  cidr_block              = length(var.public_subnet_cidr_blocks) > 0 ? var.public_subnet_cidr_blocks[count.index] : cidrsubnet(local.public_cidr_block, 2, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(var.public_subnet_tags, {
    Name = "Spacelift Public Subnet (${var.suffix} - ${count.index})"
  })
}
