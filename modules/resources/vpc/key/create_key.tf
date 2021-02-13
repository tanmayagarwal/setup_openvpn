variable "path_to_public_key" {}
variable "key_name" {}
variable "key_tags" {
	type=map
	default={}
}


resource "aws_key_pair" "mykey" {
  key_name          = var.key_name
  public_key        = "${file(var.path_to_public_key)}"
  tags              = var.key_tags
}

output "key_output" {
	value = aws_key_pair.mykey
}
