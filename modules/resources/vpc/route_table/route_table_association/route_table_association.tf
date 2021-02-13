# route public associations.......................

variable "subnet_id" {
	default = null
}
variable "gateway_id" {
	default = null
}
variable "route_table_id" {}





resource "aws_route_table_association" "main-association" {
  subnet_id      = var.subnet_id             // Please note that one of either subnet_id or gateway_id is required.
  gateway_id     = var.gateway_id
  route_table_id = var.route_table_id
}





output "route_table_association_output" {
  value = aws_route_table_association.main-association.id
}



