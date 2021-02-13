variable "route_table_vpc_id" {}
variable "route_table_tags" {
  type=map
  default={}
}
variable "routes" {
  type = list(object({
    cidr_block = string
    id = string
    type = string
  }))
}

# route_tables...........

resource "aws_route_table" "main" {
  vpc_id                = var.route_table_vpc_id
  tags                  = var.route_table_tags

  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block = route.value.cidr_block
      instance_id = route.value.type == "instance_id" ? route.value.id : ""
      gateway_id = route.value.type == "gateway_id" ? route.value.id : ""
      vpc_peering_connection_id = route.value.type == "vpc_peering_connection_id" ? route.value.id : ""
      transit_gateway_id = route.value.type == "transit_gateway_id" ? route.value.id : ""
      network_interface_id = route.value.type == "network_interface_id" ? route.value.id : ""
      nat_gateway_id = route.value.type == "nat_gateway_id" ? route.value.id : ""
      egress_only_gateway_id = route.value.type == "egress_only_gateway_id" ? route.value.id : ""
      ipv6_cidr_block = route.value.type == "ipv6_cidr_block" ? route.value.id : ""
    }
  }
}

output "route_table_main_output" {
  value = aws_route_table.main
}
