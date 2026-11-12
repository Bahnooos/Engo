resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-public-rtb"
    Type = "public"

  }
}

resource "aws_route_table_association" "public_rtb_association" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

# Private Route Table and Association
resource "aws_route_table" "private_rtb" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-private-rtb-${count.index + 1}"
    Type = "private"
  }

}

resource "aws_route_table_association" "private_rtb_association" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.private_rtb[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route" "private_nat" {
  count                  = length(var.availability_zones)
  route_table_id         = aws_route_table.private_rtb[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}