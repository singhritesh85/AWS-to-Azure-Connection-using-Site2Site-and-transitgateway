
variable "prefix" {
  description = "Provide the prefix name to be used"
  type = string
}

variable "outbound_public_ip_vpn_gtw_tunnet_1" {
  description = "Provide the Outbound Public IP for Virtual Network Gateway for Tunnet 1"
  type = string
}

variable "outbound_public_ip_vpn_gtw_tunnet_2" {
  description = "Provide the Outbound Public IP for Virtual Network Gateway for Tunnet 2"
  type = string
}

variable "virtual_network_gateway_id" {
  description = "Provide the Azure Virtual network Gateway ID"
  type = string
}

variable "aws_vpc_cidr" {
  description = "Provide the AWS VPC CIDR"
  type = list
}

data "azurerm_resource_group" "rg" {
  name = "mederma-rg"
#  location = "East US"
}

variable "shared_key_1" {
  description = "Provide the Shared Key from Dowloaded configuration file for Tunnel 1"
  type = string
}

variable "shared_key_2" {
  description = "Provide the Shared Key from Dowloaded configuration file for Tunnel 2"
  type = string
}

variable "env" {
  description = "Select the Environment among dev, stage and prod"
  type = list
}
