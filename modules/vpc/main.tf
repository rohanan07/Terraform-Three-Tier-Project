resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Three Tier Arhcitecture TF VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "frontend_subnets" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.frontend_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "backend_subnets" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.backend_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "backend-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "db_subnets" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.db_subnets_cidr, count.index)
  tags = {
    Name = "db_subnet-${count.index+1}"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_eip" "nat_eip" {
  count = length(var.availability_zones)
  domain = "vpc"
  depends_on = [ aws_internet_gateway.main_igw ]
}

resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id
  depends_on = [ aws_eip.nat_eip ]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "public_internet" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_subnet_assc" {
  count = length(var.availability_zones)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "frontend_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "frontend_nat" {
  count = length(var.availability_zones)
  route_table_id = aws_route_table.frontend_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "frontend_subnet_assc" {
  count = length(var.availability_zones)
  subnet_id = aws_subnet.frontend_subnets[count.index].id
  route_table_id = aws_route_table.frontend_rt.id
}

resource "aws_route_table" "backend_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "backend_nat" {
  count = length(var.availability_zones)
  route_table_id = aws_route_table.backend_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "backend_subnet_assc" {
  count = length(var.availability_zones)
  subnet_id = aws_subnet.backend_subnets[count.index].id
  route_table_id = aws_route_table.backend_rt.id
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "db_nat" {
  count = length(var.availability_zones)
  route_table_id = aws_route_table.db_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "db_subnet_assc" {
  count = length(var.availability_zones)
  subnet_id = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.db_rt.id
}