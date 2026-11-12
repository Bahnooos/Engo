resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-igw"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"
  tags = {
    Name        = "${var.project_name}-nat-eip-${count.index + 1}"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

}
resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name        = "${var.project_name}-nat-gw-${count.index + 1}"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
  depends_on = [aws_internet_gateway.main]
}