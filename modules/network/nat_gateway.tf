resource "aws_eip" "eips" {
  count = 3

  tags = {
    Name = "Spacelift NAT Gateway IP (${var.suffix} - ${count.index})"
  }
}

resource "aws_nat_gateway" "nat_gateways" {
  count = 3

  allocation_id = element(aws_eip.eips.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)

  tags = {
    Name = "Spacelift NAT Gateway (${var.suffix} - ${count.index})"
  }
}

resource "aws_route_table" "nat_gateway" {
  count = 3

  vpc_id = aws_vpc.spacelift_vpc.id

  # Allows traffic from within the VPC/subnet to target the NAT Gateway and
  # reach the public internet.
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateways.*.id, count.index)
  }

  tags = {
    Name = "Spacelift NAT Gateway Route Table (${var.suffix} - ${count.index})"
  }
}

resource "aws_route_table_association" "nat_gateway" {
  count = 3

  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.nat_gateway.*.id, count.index)
}

