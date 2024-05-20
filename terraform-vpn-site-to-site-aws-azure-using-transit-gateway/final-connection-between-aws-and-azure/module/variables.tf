variable "prefix" {

}

variable "outbound_public_ip_vpn_gtw_tunnet_1" {

}

variable "outbound_public_ip_vpn_gtw_tunnet_2" {

}

variable "virtual_network_gateway_id" {

}

variable "aws_vpc_cidr" {

}

data "azurerm_resource_group" "rg" {
  name = "mederma-rg"
#  location = "East US"
}

variable "shared_key_1" {

}

variable "shared_key_2" {

}

variable "env" {

}
