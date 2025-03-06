resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.spacelift_vpc.id
}

resource "aws_route_table" "internet_gateway" {
  vpc_id = aws_vpc.spacelift_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "internet_gateway" {
  count = 3

  route_table_id = aws_route_table.internet_gateway.id
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
}
