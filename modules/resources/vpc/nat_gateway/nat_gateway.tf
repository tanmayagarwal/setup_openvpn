variable "nat_allocation_id" {}
variable "nat_subnet_id" {}

variable "nat_tags" {
	type=map
	default = {}
}


resource "aws_nat_gateway" "gw" {
  allocation_id = var.nat_allocation_id
  subnet_id     = var.nat_subnet_id

  tags = var.nat_tags
}

output "nat_gateway_output" {
	value = aws_nat_gateway.gw
}
