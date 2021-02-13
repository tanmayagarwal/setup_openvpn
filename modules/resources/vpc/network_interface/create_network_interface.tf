variable "private_ips" {
  default = null
}

variable "security_groups" {
  default = []
}

variable "subnet_id" {}

variable "tags" {}

resource "aws_network_interface" "interface" {
  subnet_id       = var.subnet_id
  private_ips     = var.private_ips
  security_groups = split(",", var.security_groups)
  tags            = var.tags
}

output "network_interface" {
  value = aws_network_interface.interface
}
