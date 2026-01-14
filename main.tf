module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  public_subnets_cidr = var.public_subnets_cidr
  frontend_subnets_cidr = var.frontend_subnets_cidr
  backend_subnets_cidr = var.backend_subnets_cidr
  db_subnets_cidr = var.db_subnets_cidr
  availability_zones = var.availability_zones
}

module "security_groups" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id #passing the output vpc_id from vpc module
}