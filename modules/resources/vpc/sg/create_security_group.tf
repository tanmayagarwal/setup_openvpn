variable "sg_name" {
  default = ""
}
variable "sg_description" {
  default = "Allows TLS inbound traffic"
}
variable "sg_vpc_id" {
  default = ""
}
variable "sg_tags" {
  type=map
  default = {}
}

variable "sg_revoke_rules_on_delete" {
  default = null
}

variable "ingress_group_parameters" {
  type = list(object({
    
    description = string
    from_port = string
    to_port = string
    protocol = string
    cidr_blocks = list(string)
    security_groups = list(string)
    self = bool
    
  }))
}

variable "egress_group_parameters" {
  type = list(object({
   
    description = string
    from_port = string
    to_port = string
    protocol = string
    cidr_blocks = list(string)
    security_groups = list(string)
    self = bool
    
  }))
}





resource "aws_security_group" "security_group" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.sg_vpc_id
  revoke_rules_on_delete = var.sg_revoke_rules_on_delete == null ? null : var.sg_revoke_rules_on_delete

  tags = var.sg_tags
  

  dynamic "ingress" {
    for_each = var.ingress_group_parameters
    content {
      
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
      self = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = var.egress_group_parameters
    content {
      
      description = egress.value.description
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      security_groups = egress.value.security_groups
      self = egress.value.self
    }
  }


  lifecycle {
  ignore_changes = [description]
  }

}





output "security_group_output" {
  value =  aws_security_group.security_group  
}






