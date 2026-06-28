output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = {
    for k, v in aws_subnet.public :
    k => v.id
  }
}

output "private_subnet_ids" {
  value = {
    for k, v in aws_subnet.private :
    k => v.id
  }
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}