variable "subnet_cidr_block" {}
variable "subnet_vpc_id" {}
variable "subnet_availability_zone" {}
variable "subnet_tags" {
	type=map
	default={}
}
variable "map_public_ip_on_launch" {
	default = "false"
}
resource "aws_subnet" "main" {
  
  vpc_id                  = var.subnet_vpc_id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.subnet_availability_zone
  tags                    = var.subnet_tags
}

output "subnet_output"{
	value = aws_subnet.main
}


