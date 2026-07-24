data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  azs          = local.azs
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  enable_logs       = var.enable_alb_logs
}

module "compute" {
  source             = "./modules/compute"
  project_name       = var.project_name
  instance_type      = var.instance_type
  key_name           = var.key_name
  private_subnet_ids = module.vpc.private_app_subnet_ids
  app_sg_id          = module.security.app_sg_id
  target_group_arn   = module.alb.target_group_arn
  asg_min            = var.asg_min
  asg_max            = var.asg_max
  asg_desired        = var.asg_desired
  user_data_path     = "${path.module}/../scripts/userdata.sh"
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_db_subnet_ids
  db_sg_id           = module.security.db_sg_id
  instance_class     = var.db_instance_class
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
}
