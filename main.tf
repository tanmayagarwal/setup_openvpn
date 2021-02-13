provider "aws" {
  region     = "ap-southeast-1"
}

module "create_vpc" {
  source = "./modules/resources/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  vpc_enable_dns_hostnames = var.vpc_enable_dns_hostnames
  vpc_tags = var.vpc_tags
}

output "vpc_id" {
 value = module.create_vpc.vpc_output.id
}

//Create  public subnet
module "create_public_1a_subnet" {
  source = "./modules/resources/vpc/subnet"
  subnet_cidr_block = var.subnet_cidr_block_public_1a
  subnet_vpc_id = module.create_vpc.vpc_output.id
  subnet_availability_zone = var.subnet_availability_zone_public_1a
  subnet_tags = var.subnet_public_1a_tags
}
output "public_1a_subnet" {
 value = module.create_public_1a_subnet.subnet_output.id
}

//Create elastic IP
module "create_elastic_ip" {
  source = "./modules/resources/vpc/elastic_ip"
  elastic_tags = var.elastic_tags
  elastic_vpc = var.elastic_vpc
}
output "elastic_ip" {
  value = module.create_elastic_ip.elastic_ip_output.public_ip
}

//Create Internet  gateway
module "create_internet_gateway" {
  source = "./modules/resources/vpc/igw"
  igw_vpc_id  = module.create_vpc.vpc_output.id
  igw_tags = var.igw_tags
}

output "internet_gateway" {
  value = module.create_internet_gateway.ig_output.id
}

//Create NAT gateway
module "create_nat_gateway" {
        source  = "./modules/resources/vpc/nat_gateway"
        nat_tags = var.nat_tags
        nat_subnet_id = module.create_public_1a_subnet.subnet_output.id
        nat_allocation_id = module.create_elastic_ip.elastic_ip_output.id
}
output "nat_gateway" {
  value = module.create_nat_gateway.nat_gateway_output.id
}

//Create  private subnet
module "create_private_1a_subnet" {
  source = "./modules/resources/vpc/subnet"
  subnet_cidr_block = var.subnet_cidr_block_private_1a
  subnet_vpc_id = module.create_vpc.vpc_output.id
  subnet_availability_zone = var.subnet_availability_zone_private_1a
  subnet_tags = var.subnet_private_1a_tags
}
output "private_1a_subnet" {
 value = module.create_private_1a_subnet.subnet_output.id
}




//Create public route table
resource "aws_route_table" "create_public_route_table" {
  vpc_id                = module.create_vpc.vpc_output.id
  tags                  = var.route_table_tags_public
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.create_internet_gateway.ig_output.id
  }
}

output "public_route_table_id" {
  value = aws_route_table.create_public_route_table.id
}



//Create private route table
resource "aws_route_table" "create_private_route_table" {
  vpc_id                = module.create_vpc.vpc_output.id
  tags                  = var.route_table_tags_private
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = module.create_nat_gateway.nat_gateway_output.id
  }
}

output "private_route_table_id" {
  value = aws_route_table.create_private_route_table.id
}



//Create route table association
module "create_private_subnet_to_private_route_1a" {
  source = "./modules/resources/vpc/route_table/route_table_association"
  subnet_id = module.create_private_1a_subnet.subnet_output.id
  route_table_id = aws_route_table.create_private_route_table.id
}

module "create_public_subnet_to_public_route_1a" {
  source = "./modules/resources/vpc/route_table/route_table_association"
  subnet_id = module.create_public_1a_subnet.subnet_output.id
  route_table_id = aws_route_table.create_public_route_table.id
}


//Create ssh private security group along with few default ports
module "create_private_ssh_sg" {
  source  = "./modules/resources/vpc/sg"
  sg_name = var.sg_name_ssh_private
  sg_description = var.sg_description_ssh_private
  sg_tags = var.sg_tags_ssh_private
  sg_vpc_id = module.create_vpc.vpc_output.id
  ingress_group_parameters = var.ingress_group_parameters_ssh_private
  egress_group_parameters = var.egress_group_parameters_ssh_private
}

output "ssh_private_sg" {
  value = module.create_private_ssh_sg.security_group_output.id
}

//Create ssh public security group along with few default ports
module "create_public_ssh_sg" {
        source  = "./modules/resources/vpc/sg"
        sg_name = var.sg_name_ssh_public
        sg_description = var.sg_description_ssh_public
        sg_tags = var.sg_tags_ssh_public
        sg_vpc_id = module.create_vpc.vpc_output.id
        ingress_group_parameters = var.ingress_group_parameters_ssh_public
        egress_group_parameters = var.egress_group_parameters_ssh_public
}

output "ssh_public_sg" {
        value = module.create_public_ssh_sg.security_group_output.id
}

module "create_vpn_sg" {
        source  = "./modules/resources/vpc/sg"
        sg_name = var.sg_name_vpn
        sg_description = var.sg_description_vpn
        sg_tags = var.sg_tags_vpn
        sg_vpc_id = module.create_vpc.vpc_output.id
        ingress_group_parameters = var.ingress_group_parameters_vpn
        egress_group_parameters = var.egress_group_parameters_vpn
}

output "ssh_vpn_sg" {
        value = module.create_vpn_sg.security_group_output.id
}


resource "aws_key_pair" "mykeypair" {
  key_name   = "tanmay_test_key"
  public_key = "${file(var.key_location)}"
}

output "access_key_id" {
        value = aws_key_pair.mykeypair.id
}

/*
module "create_ec2_bastion_host" {
  node_count = 1
  source = "./modules/resources/ec2"
  instance_type = var.bastion_host["instance_type"]
  subnet_id = module.create_public_1a_subnet.subnet_output.id
  ami_id = var.bastion_host["ami_id"]
  security_group = module.create_public_ssh_sg.security_group_output.id
  cpu_credits = var.bastion_host["cpu_credits"]
  tags = var.bastion_host["tags"]
  key_name = aws_key_pair.mykeypair.id
  associate_public_ip_address = var.bastion_host["associate_public_ip_address"]
}

output "bastion_host" {
    value = module.create_ec2_bastion_host.create_output[*].public_ip
}
  

module "create_ec2_private_ec2" {
  node_count = 1
  source = "./modules/resources/ec2"
  instance_type = var.private_ec2["instance_type"]
  subnet_id = module.create_private_1a_subnet.subnet_output.id
  ami_id = var.private_ec2["ami_id"]
  security_group = module.create_private_ssh_sg.security_group_output.id
  cpu_credits = var.private_ec2["cpu_credits"]
  tags = var.private_ec2["tags"]
  key_name = aws_key_pair.mykeypair.id
  associate_public_ip_address = var.private_ec2["associate_public_ip_address"]
}

output "private_ec2" {
    value = module.create_ec2_private_ec2.create_output[*].private_ip
}

*/


module "create_ec2_vpn" {
  node_count = 1
  source = "./modules/resources/ec2"
  instance_type = var.ec2_vpn["instance_type"]
  subnet_id = module.create_public_1a_subnet.subnet_output.id
  ami_id = var.ec2_vpn["ami_id"]
  security_group = module.create_vpn_sg.security_group_output.id
  cpu_credits = var.ec2_vpn["cpu_credits"]
  tags = var.ec2_vpn["tags"]
  key_name = aws_key_pair.mykeypair.id
  associate_public_ip_address = var.ec2_vpn["associate_public_ip_address"]
  user_data = <<EOF
#!/usr/bin/env bash
exec > >(tee -ia /tmp/userdata.log)
${file("./user-data.sh")}
EOF
}

output "ec2_vpn_id" {
    value = module.create_ec2_vpn.create_output[*].public_ip
}

module "create_elastic_ip_vpn" {
  source = "./modules/resources/vpc/elastic_ip"
  elastic_tags = var.elastic_tags_vpn
  elastic_vpc = var.elastic_vpc
  elastic_instance = module.create_ec2_vpn.create_output[0].id
}
output "elastic_ip_vpn" {
  value = module.create_elastic_ip_vpn.elastic_ip_output.public_ip
}

output "vpn_server_dns" {
  value = module.create_elastic_ip_vpn.elastic_ip_output.public_dns
}
