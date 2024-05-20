variable "vpc_cidr1"{

}

variable "vpc_cidr2"{

}

variable "private_subnet_cidr1"{

}

variable "private_subnet_cidr2"{

}

variable "public_subnet_cidr1"{

}

variable "public_subnet_cidr2"{

}

variable "igw_name1" {

}

variable "igw_name2" {

}

variable "vpc_name1" {

}

variable "vpc_name2" {

}

variable "env" {

}

data aws_availability_zones azs {

}

############################## variables to launch EC2 ###################################

variable "instance_count" {

}

variable "provide_ami" {

}

variable "instance_type" {

}

variable "kms_key_id" {

}

variable "name" {

}

############################### Site to Site VPN #########################################

variable "ip_address_azure_vpn_gtw" {

}

variable "azure_vnet_subnet_cidr_block" {

}

############################### Terraform Data Source ####################################

#data "aws_ec2_transit_gateway_vpn_attachment" "vpn_attachment" {
#  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
#  vpn_connection_id  = aws_vpn_connection.site2site_vpn.id
#}
