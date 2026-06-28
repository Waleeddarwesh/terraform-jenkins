########################################
# VPC
########################################

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }

}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }

}

########################################
# Public Subnets
########################################

resource "aws_subnet" "public" {

  for_each = var.public_subnets

  vpc_id = aws_vpc.main.id

  cidr_block = each.value.cidr

  availability_zone = each.value.az

  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }

}

########################################
# Private Subnets
########################################

resource "aws_subnet" "private" {

  for_each = var.private_subnets

  vpc_id = aws_vpc.main.id

  cidr_block = each.value.cidr

  availability_zone = each.value.az

  tags = {
    Name = each.key
  }

}

########################################
# Elastic IP
########################################

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }

}

########################################
# NAT Gateway
########################################

resource "aws_nat_gateway" "nat_gw" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = values(aws_subnet.public)[0].id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "nat-gateway"
  }

}

########################################
# Public Route Table
########################################

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "public-route-table"
  }

}

########################################
# Public Route Associations
########################################

resource "aws_route_table_association" "public_assoc" {

  for_each = aws_subnet.public

  subnet_id = each.value.id

  route_table_id = aws_route_table.public_rt.id

}

########################################
# Private Route Tables
########################################

resource "aws_route_table" "private_rt" {

  for_each = aws_subnet.private

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_gw.id

  }

  tags = {
    Name = "${each.key}-route-table"
  }

}

########################################
# Private Route Associations
########################################

resource "aws_route_table_association" "private_assoc" {

  for_each = aws_subnet.private

  subnet_id = each.value.id

  route_table_id = aws_route_table.private_rt[each.key].id

}