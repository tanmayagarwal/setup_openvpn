variable "elastic_vpc" {
	default = "false"
}
variable "elastic_instance" {
	default = ""
}
variable "elastic_network_interface" {
	default = ""
}
variable "elastic_associate_with_private_ip" {
	default = ""
}
variable "elastic_public_ipv4_pool" {
	default = ""
}
variable "elastic_tags" {
	type=map
	default = {}
}



resource "aws_eip" "elastic_ip" {
  vpc                            = var.elastic_vpc
  instance                       = var.elastic_instance
  network_interface              = var.elastic_network_interface
  associate_with_private_ip      = var.elastic_associate_with_private_ip
  public_ipv4_pool               = var.elastic_public_ipv4_pool
  tags                           = var.elastic_tags
}


output "elastic_ip_output" {
	value = aws_eip.elastic_ip
}