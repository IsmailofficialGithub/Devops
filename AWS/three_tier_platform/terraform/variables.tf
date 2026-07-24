variable "project_name" { type = string }
variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }
variable "az_count" { type = number }
variable "instance_type" { type = string }
variable "asg_min" { type = number }
variable "asg_max" { type = number }
variable "asg_desired" { type = number }
variable "db_instance_class" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "key_name" {
  type    = string
  default = ""
}
variable "enable_alb_logs" {
  type    = bool
  default = true
}
