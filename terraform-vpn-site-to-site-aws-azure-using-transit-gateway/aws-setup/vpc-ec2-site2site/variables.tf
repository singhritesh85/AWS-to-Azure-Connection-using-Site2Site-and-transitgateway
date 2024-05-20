variable "region" {
  type = string
  description = "Provide the AWS Region into which VPC to be created"
}

variable "vpc_cidr1"{
  description = "Provide the CIDR for VPC-1"
  type = string
}

variable "vpc_cidr2"{
  description = "Provide the CIDR for VPC-2"
  type = string
}

variable "private_subnet_cidr1"{
  description = "Provide the cidr for Private Subnet of VPC-1"
  type = list
}

variable "private_subnet_cidr2"{
  description = "Provide the cidr for Private Subnet of VPC-2"
  type = list
}

variable "public_subnet_cidr1"{
  description = "Provide the cidr of the Public Subnet of VPC-1"
  type = list
}

variable "public_subnet_cidr2"{
  description = "Provide the cidr of the Public Subnet of VPC-2"
  type = list
}

variable "igw_name1" {
  description = "Provide the Name of Internet Gateway for VPC-1"
  type = string
}

variable "igw_name2" {
  description = "Provide the Name of Internet Gateway for VPC-2"
  type = string
}

variable "vpc_name1" {
  description = "Provide the Name of VPC-1"
  type = string
}

variable "vpc_name2" {
  description = "Provide the Name of VPC-2"
  type = string
}

variable "env" {
  type = list
  description = "Provide the Environment for AWS Resources to be created"
}

data aws_availability_zones azs {

}

########################################### variables to launch EC2 ############################################################

variable "instance_count" {
  description = "Provide the Instance Count"
  type = number
}

variable "provide_ami" {
  description = "Provide the AMI ID for the EC2 Instance"
  type = map
}

variable "instance_type" {
  description = "Provide the Instance Type"
  type = list
}

variable "kms_key_id" {
  description = "Provide the KMS Key ID to Encrypt EBS"
  type = string
}

variable "name" {
  description = "Provide the name of the EC2 Instance"
  type = string
}

############################################# AWS VPN Site-to-Site ##############################################################

variable "ip_address_azure_vpn_gtw" {
  description = "Provide Public IP Address of Azure VPN Gateway"
  type = string
}

variable "azure_vnet_subnet_cidr_block" {
  description = "Provide Azure VNet Subnet CIDR block"
  type = list
}

############################################# Terraform Data Source ############################################################

#data "aws_ec2_transit_gateway_vpn_attachment" "vpn_attachment" {
#  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
#  vpn_connection_id  = aws_vpn_connection.site2site_vpn.id
#}
