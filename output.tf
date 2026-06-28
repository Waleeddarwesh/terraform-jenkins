output "vpc_id" {

  value = module.network.vpc_id

}

output "public_subnet_ids" {

  value = module.network.public_subnet_ids

}

output "private_subnet_ids" {

  value = module.network.private_subnet_ids

}

output "alb_dns_name" {

  value = module.ec2.alb_dns_name

}

output "instance_ids" {

  value = module.ec2.instance_ids

}