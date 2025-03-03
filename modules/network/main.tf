data "aws_availability_zones" "available" {}

resource "aws_vpc" "spacelift_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = false
  enable_dns_support   = true
}

resource "aws_subnet" "private_subnets" {
  count = 3

  vpc_id                  = aws_vpc.spacelift_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, var.subnet_mask_size, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
}

resource "aws_security_group" "drain_sg" {
  name        = "drain_sg"
  description = "The security group for the Spacelift async-processing service"
  vpc_id      = aws_vpc.spacelift_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "drain_sg_egress_rule" {
  security_group_id = aws_security_group.drain_sg.id
  description       = "Unrestricted egress"
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "server_sg" {
  name        = "server_sg"
  description = "The security group for the Spacelift HTTP server"
  vpc_id      = aws_vpc.spacelift_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "server_sg_egress_rule" {
  security_group_id = aws_security_group.server_sg.id
  description       = "Unrestricted egress"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "The security group defining what services can access the Spacelift database"
  vpc_id      = aws_vpc.spacelift_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "database_drain_ingress_rule" {
  security_group_id = aws_security_group.database_sg.id

  description                  = "Only accept TCP connections on appropriate port from the drain"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.drain_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "database_server_ingress_rule" {
  security_group_id = aws_security_group.database_sg.id

  description                  = "Only accept TCP connections on appropriate port from the server"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.server_sg.id
}
