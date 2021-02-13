variable "ami_id" {}
variable "instance_type" {}
variable "security_group" {}
variable "subnet_id" {}
variable "node_count" {
  default = "1"
}
variable "cpu_credits" {
  default = "standard"
}
variable "associate_public_ip_address" {
  type = bool
  default = true
}
variable "key_name" {
  default = "aws-stage"
}
variable "user_data" {
  default =""
}
variable "tags" {}
variable "private_ip" {
  default  = ""
}

variable "monitoring" {
  default = false
}

resource "aws_instance" "ec2" {
  count                          = var.node_count
  ami                            = var.ami_id
  instance_type                  = var.instance_type
  vpc_security_group_ids         = split(",", var.security_group)
  subnet_id                      = var.subnet_id
  associate_public_ip_address    = var.associate_public_ip_address
  user_data                      = var.user_data
  key_name                       = var.key_name
  private_ip                     = var.private_ip
  tags                           = var.tags
  monitoring                     = var.monitoring
  credit_specification {
    cpu_credits = var.cpu_credits
  }

}

output "create_output" {
  description = "Id of the ec2 instance"
  //value = join(",",tolist(aws_instance.ec2.*.id))
 value = aws_instance.ec2

}
