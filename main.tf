########################################
# Network Module
########################################

module "network" {

  source = "./modules/network"

  vpc_cidr = var.vpc_cidr

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

}

########################################
# EC2 Module
########################################

module "ec2" {

  source = "./modules/EC2"

  vpc_id = module.network.vpc_id

  public_subnet_ids = module.network.public_subnet_ids

  instance_count = var.instance_count

  ami_id = var.ami_id

  instance_type = var.instance_type

  ssh_ip = var.ssh_ip

}
