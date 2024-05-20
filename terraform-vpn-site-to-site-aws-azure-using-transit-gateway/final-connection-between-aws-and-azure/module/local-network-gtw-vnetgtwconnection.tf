################################## Local Network Gateway 1 ###########################################

resource "azurerm_local_network_gateway" "local_network_gtw_1" {
  name                = "${var.prefix}-lngtw-1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  gateway_address     = var.outbound_public_ip_vpn_gtw_tunnet_1
  address_space       = var.aws_vpc_cidr

  tags = {
    environment = var.env
  }

}

################################## Local Network Gateway 2 ###########################################

resource "azurerm_local_network_gateway" "local_network_gtw_2" {
  name                = "${var.prefix}-lngtw-2"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  gateway_address     = var.outbound_public_ip_vpn_gtw_tunnet_2
  address_space       = var.aws_vpc_cidr

  tags = {
    environment = var.env
  }

}

################################## Azure Virtual Network Gateway Connection 1 ########################

resource "azurerm_virtual_network_gateway_connection" "connection1" {
  name                = "${var.prefix}-connection1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  type                            = "IPsec"
  virtual_network_gateway_id      = var.virtual_network_gateway_id       ###azurerm_virtual_network_gateway.vnetgtw.id
  local_network_gateway_id        = azurerm_local_network_gateway.local_network_gtw_1.id

  shared_key = var.shared_key_1          ### Shared Key for Tunnel 1

  tags = {
    environment = var.env
  }

}

################################## Azure Virtual Network Gateway Connection 2 ########################

resource "azurerm_virtual_network_gateway_connection" "connection2" {
  name                = "${var.prefix}-connection2"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  type                            = "IPsec"
  virtual_network_gateway_id      = var.virtual_network_gateway_id       ###azurerm_virtual_network_gateway.vnetgtw.id
  local_network_gateway_id        = azurerm_local_network_gateway.local_network_gtw_2.id

  shared_key = var.shared_key_2         ### Shared Key for Tunnel 2

  tags = {
    environment = var.env
  }

}
