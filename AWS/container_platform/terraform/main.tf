data "aws_availability_zones" "available" { state = "available" }

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
  source         = "./modules/security"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  container_port    = var.container_port
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  db_sg_id           = module.security.db_sg_id
  instance_class     = var.db_instance_class
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
}

module "elasticache" {
  source             = "./modules/elasticache"
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  redis_sg_id        = module.security.redis_sg_id
  node_type          = var.redis_node_type
}

module "messaging" {
  source       = "./modules/messaging"
  project_name = var.project_name
}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  task_sg_id         = module.security.task_sg_id
  target_group_arn   = module.alb.target_group_arn
  container_image    = var.container_image
  container_port     = var.container_port
  desired_count      = var.desired_count
  cpu                = var.cpu
  memory             = var.memory
  db_secret_arn      = module.rds.secret_arn
  redis_endpoint     = module.elasticache.primary_endpoint
  sqs_queue_url      = module.messaging.queue_url
  sns_topic_arn      = module.messaging.topic_arn
}
