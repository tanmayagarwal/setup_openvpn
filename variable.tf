variable "vpc_tags" {
    default = {
        "Name" = "test_vpc",
        "Provissioned_By" = "terraform"
    }
}
variable "vpc_cidr_block" {
     default = "172.22.0.0/16"
}
variable "vpc_enable_dns_hostnames" {
    default = true
}


variable "subnet_map_public_ip_on_launch" {
    default = "true"
}
variable "subnet_cidr_block_private_1a" {
      default = "172.22.2.0/24"
}
variable "subnet_availability_zone_private_1a" {
    default = "ap-southeast-1a"
}
variable "subnet_private_1a_tags" {
    default = {
      "Name" = "test_private_1a",
      "Provissioned_By" = "terraform"
      
    }
}


variable "subnet_cidr_block_public_1a" {
    default = "172.22.1.0/24"
}
variable "subnet_availability_zone_public_1a" {
    default = "ap-southeast-1a"
}
variable "subnet_public_1a_tags" {
    default = {
      "Name" = "test_public_1a",
      "Provissioned_By" = "terraform"
    }
}



variable "route_table_tags_private" {
    default = {
      "Name" = "test_route_private",
      "Provissioned_By" = "terraform"
    }
}
variable "route_table_tags_public" {
    default = {
      "Name" = "test_route_public",
      "Provissioned_By" = "terraform"
    }
}



variable "elastic_tags" {
    default = {
    "Name" = "test_eip",
    "Provissioned_By" = "terraform"
   }
}

variable "elastic_tags_vpn" {
    default = {
    "Name" = "openvpn",
    "Provissioned_By" = "terraform"
   }
}

variable "elastic_vpc" {
    default = "true"
}

variable "nat_tags" {
    default = {
      "Name" = "test_nat_gateway",
      "Provissioned_By" = "terraform"
    }
}

variable "igw_tags" {
    default = {
      "Name" = "test_igw",
      "Provissioned_By" = "terraform"
    }
}

variable "sg_name_ssh_public" {
    default = "sg_ssh_public"
}
variable "sg_description_ssh_public" {
    default = "Allow port 22"
}
variable "sg_tags_ssh_public" {
    default = {
        "Name" = "test_sg_ssh_public"
        "Provissioned_By" = "terraform"
    }
}
variable "ingress_group_parameters_ssh_public" {
    default = [
        {
                from_port = 22
                to_port = 22
                cidr_blocks = [ "0.0.0.0/0" ]
                protocol = "tcp"
                description = "Allow ssh from all"
                security_groups = []
                self = false
        }
    ]
}
variable "egress_group_parameters_ssh_public" {
    default = [
        {
                from_port = 0
                to_port = 0
                cidr_blocks = [ "0.0.0.0/0" ]
                protocol = "-1"
                description = ""
                security_groups = []
                self = false
        }
    ]
}

variable "sg_name_ssh_private" {
    default = "ssh_private"
}
variable "sg_description_ssh_private" {
    default = "Allow port 22"
}
variable "sg_tags_ssh_private" {
    default = {
    "Name" = "test_sg_ssh_private"
    "Provissioned_By" = "terraform"
    }
}
variable "ingress_group_parameters_ssh_private" {
    default = [
    {
        from_port = 22
        to_port = 22
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        description = "Allow ssh from jump server"
    security_groups = []
    self = false
    }
    ]
}
variable "egress_group_parameters_ssh_private" {
    default = [
    {
        from_port = 0
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        description = ""
    security_groups = []
    self = false
    }
    ]
}

variable "sg_name_vpn" {
    default = "vpn-sg"
}
variable "sg_description_vpn" {
    default = "OpenVPN Security Group"
}
variable "sg_tags_vpn" {
    default = {
    "Name" = "vpn-sg"
    "Provissioned_By" = "terraform"
    }
}


variable "ingress_group_parameters_vpn" {
    default = [
        {
            from_port = 22
            to_port = 22
            cidr_blocks = [ "0.0.0.0/0" ]
            protocol = "tcp"
            description = ""
            security_groups = []
            self = false
        },
        
        {
            from_port = 443
            to_port = 443
            cidr_blocks = [ "0.0.0.0/0" ]
            protocol = "tcp"
            description = ""
            security_groups = []
            self = false
        },

        {
            from_port = 943
            to_port = 943
            cidr_blocks = [ "0.0.0.0/0" ]
            protocol = "tcp"
            description = ""
            security_groups = []
            self = false
        },

        {
            from_port = 1194
            to_port = 1194
            cidr_blocks = [ "0.0.0.0/0" ]
            protocol = "udp"
            description = ""
            security_groups = []
            self = false
        }
    ]
    
}
variable "egress_group_parameters_vpn" {
    default = [
    {
        from_port = 0
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        description = ""
    security_groups = []
    self = false
    }
    ]
}


variable "key_location" {
    default  = "tanmay_test.pem"
}

variable "bastion_host" {
        default = {
                "ami_id" = "ami-0d728fd4e52be968f",
                "cpu_credits" = "unlimited",
                "instance_type" = "t3a.micro",
                "associate_public_ip_address" = true,
                "tags" = {
                        "Name" = "bastion-host",
                        "Provissioned_By" = "terraform",
                  }
        }
}
variable "ec2_vpn" {
        default = {
                "ami_id" = "ami-0a2cf15ad1bf3fef4",
                "cpu_credits" = "unlimited",
                "instance_type" = "t3.medium",
                "associate_public_ip_address" = true,
                "tags" = {
                        "Name" = "ec2-vpn",
                        "Provissioned_By" = "terraform",
                  }
        }
}

variable "private_ec2" {
        default = {
                "ami_id" = "ami-0d728fd4e52be968f",
                "cpu_credits" = "unlimited",
                "instance_type" = "t3a.micro",
                "associate_public_ip_address" = false,
                "tags" = {
                        "Name" = "private-ec2",
                        "Provissioned_By" = "terraform",
                  }
        }
}
