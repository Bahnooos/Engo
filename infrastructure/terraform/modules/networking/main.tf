

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    Type = "public"
  }
}
resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    Type = "private"
  }
}


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

# Public Route Table and Association
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