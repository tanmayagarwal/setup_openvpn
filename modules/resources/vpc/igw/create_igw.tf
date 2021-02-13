variable "igw_vpc_id" {}
variable "igw_tags" {
	type=map
	default={}
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id                   = var.igw_vpc_id
  tags                     = var.igw_tags
}


output "ig_output" {
	value = aws_internet_gateway.main-igw
}