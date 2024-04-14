resource "aws_vpc" "network" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  count = length(var.aws.availability_zones)
  vpc_id = aws_vpc.network.id
  availability_zone = var.aws.availability_zones[count.index]
  cidr_block = "10.0.${count.index}.0/24"
  tags = {
    Name = "${var.project_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.aws.availability_zones)
  vpc_id = aws_vpc.network.id
  availability_zone = var.aws.availability_zones[count.index]
  cidr_block = "10.0.${count.index + 10}.0/24"
  tags = {
    Name = "${var.project_name}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.network.id
}

resource "aws_eip" "nat" {
  tags = {
    Name = "${var.project_name}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-private"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private[count.index].id
}

resource "aws_route53_zone" "internal" {
  name = "${var.project_name}.vpc"

  vpc {
    vpc_id = aws_vpc.network.id
    vpc_region = var.aws.region
  }
}
