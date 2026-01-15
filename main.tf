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

module "iam" {
  source = "./modules/iam"
  
}

module "frontend_asg" {
  source = "./modules/frontend-asg"
  target_group_arn = module.external_alb.target_group_arn
  iam_instance_profile = module.iam.ec2_instance_profile_name
  security_group_id = module.security_groups.frontend_sg_id
  instance_type = var.instance_type
  subnet_ids = module.vpc.frontend_subnet_id
  key_name = var.key_name
  ami_id = var.ami_id
}

module "backend_asg" {
  source = "./modules/backend-asg"
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_ids = module.vpc.backend_subnet_id
  iam_instance_profile = module.iam.ec2_instance_profile_name
  security_group_id = module.security_groups.backend_sg_id
  key_name = var.key_name
  target_group_arns = [module.internal_alb.target_group_arn]
}

module "external_alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_id
  security_group_id = module.security_groups.external_alb_sg_id
  target_group_port = 3000
  internal = false
  name_prefix = "public-"
}

module "internal_alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.frontend_subnet_id
  security_group_id = module.security_groups.internal_alb_sg_id
  target_group_port = 8080
  internal = true
  name_prefix = "internal"
}