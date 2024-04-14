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
}
resource "aws_subnet" "private" {
  count = length(var.aws.availability_zones)
  vpc_id = aws_vpc.network.id
  availability_zone = var.aws.availability_zones[count.index]
  cidr_block = "10.0.${count.index + 10}.0/24"
}
