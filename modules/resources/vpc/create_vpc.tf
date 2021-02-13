#vpc

variable "vpc_tags" {
  type=map
  default={}
}
variable "vpc_cidr_block" {}
variable "vpc_instance_tenancy" {
  default = "default"
}
variable "vpc_enable_dns_support" {
  default = true
}
variable "vpc_enable_dns_hostnames" {
  default = false
}
variable "vpc_enable_classiclink" {
  default = false
}
variable "vpc_enable_classiclink_dns_support" {
  default = false
}

 
resource "aws_vpc" "main" {
  cidr_block                        = var.vpc_cidr_block
  instance_tenancy                  = var.vpc_instance_tenancy
  enable_dns_support                = var.vpc_enable_dns_support
  enable_dns_hostnames              = var.vpc_enable_dns_hostnames
  enable_classiclink                = var.vpc_enable_classiclink
  enable_classiclink_dns_support    = var.vpc_enable_classiclink_dns_support
  tags                              = var.vpc_tags
}


output "vpc_output" {
  value = aws_vpc.main
}

