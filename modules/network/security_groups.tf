resource "aws_security_group" "drain_sg" {
  name        = var.security_group_names != null ? var.security_group_names.drain : "drain_sg_${var.suffix}"
  description = "The security group for the Spacelift async-processing service"
  vpc_id      = aws_vpc.spacelift_vpc.id
  region      = var.region
}

resource "aws_vpc_security_group_egress_rule" "drain_sg_egress_rule" {
  security_group_id = aws_security_group.drain_sg.id
  description       = "Unrestricted egress"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  region            = var.region
}

resource "aws_security_group" "server_sg" {
  name        = var.security_group_names != null ? var.security_group_names.server : "server_sg_${var.suffix}"
  description = "The security group for the Spacelift HTTP server"
  vpc_id      = aws_vpc.spacelift_vpc.id
  region      = var.region
}

resource "aws_vpc_security_group_egress_rule" "server_sg_egress_rule" {
  security_group_id = aws_security_group.server_sg.id
  description       = "Unrestricted egress"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  region            = var.region
}

resource "aws_security_group" "vcs_gateway_sg" {
  count = var.create_vcs_gateway ? 1 : 0

  name        = var.security_group_names != null ? var.security_group_names.vcs_gateway : "vcs_gateway_sg_${var.suffix}"
  description = "The security group for the Spacelift VCS gateway service"
  vpc_id      = aws_vpc.spacelift_vpc.id
  region      = var.region
}

resource "aws_vpc_security_group_egress_rule" "vcs_gateway_sg_egress_rule" {
  count = var.create_vcs_gateway ? 1 : 0

  security_group_id = aws_security_group.vcs_gateway_sg[0].id
  description       = "Unrestricted egress"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  region            = var.region
}

resource "aws_security_group" "database_sg" {
  count = var.create_database ? 1 : 0

  name        = var.security_group_names != null ? var.security_group_names.database : "database_sg_${var.suffix}"
  description = "The security group defining what services can access the Spacelift database"
  vpc_id      = aws_vpc.spacelift_vpc.id
  region      = var.region
}
resource "aws_vpc_security_group_ingress_rule" "database_drain_ingress_rule" {
  count = var.create_database ? 1 : 0

  security_group_id = aws_security_group.database_sg[0].id

  description                  = "Only accept TCP connections on appropriate port from the drain"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.drain_sg.id
  region                       = var.region
}

resource "aws_vpc_security_group_ingress_rule" "database_server_ingress_rule" {
  count = var.create_database ? 1 : 0

  security_group_id = aws_security_group.database_sg[0].id

  description                  = "Only accept TCP connections on appropriate port from the server"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.server_sg.id
  region                       = var.region
}

resource "aws_vpc_security_group_ingress_rule" "database_vcs_gateway_ingress_rule" {
  count = var.create_database && var.create_vcs_gateway ? 1 : 0

  security_group_id = aws_security_group.database_sg[0].id
  region            = var.region

  description                  = "Only accept TCP connections on appropriate port from the VCS gateway"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.vcs_gateway_sg[0].id
}
