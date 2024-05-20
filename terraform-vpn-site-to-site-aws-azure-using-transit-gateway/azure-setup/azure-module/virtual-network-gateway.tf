resource "azurerm_resource_group" "vnetconnection_rg" {
  name     = "${var.prefix}-rg"
  location = var.location[0]
}

################################################Create VNet1#############################################################################

resource "azurerm_virtual_network" "vnet-1" {
  name                = "VNet1"
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name
  location            = azurerm_resource_group.vnetconnection_rg.location
  address_space       = ["172.19.0.0/16"]
}

resource "azurerm_subnet" "vnet1_subnet" {
  name                 = "Subnet-1"
  resource_group_name  = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["172.19.1.0/24"]
}

resource "azurerm_subnet" "vnet1_gtwsubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["172.19.2.0/24"]
}

resource "azurerm_public_ip" "vnetgtw1_ip" {
  name                = "${var.prefix}-VNGTW1-ip"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name
  allocation_method   = var.static_dynamic[0]
 
  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
#  zones = var.availability_zone

  tags = {
    environment = var.env
  } 

}

resource "azurerm_virtual_network_gateway" "vnetgtw" {
  name                = "${var.prefix}-VNGTW"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  generation = "Generation2"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vnetgtw1_ip.id
    private_ip_address_allocation = var.static_dynamic[1]
    subnet_id                     = azurerm_subnet.vnet1_gtwsubnet.id
  }
}

############################################## Create NSG 1 ######################################################

resource "azurerm_network_security_group" "azure_nsg1" {
  name                = "${var.prefix}-nsg1"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name

  security_rule {
    name                       = "azure_nsg11"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "azure_nsg12"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]  

}

################################## Public VM1 in VNet1 #####################################################

resource "azurerm_public_ip" "public_ip1" {
  name                = "${var.prefix}-ip1"
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name
  location            = azurerm_resource_group.vnetconnection_rg.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard  
  zones = var.availability_zone

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_network_interface" "vnet_interface1" {
  name                = "${var.prefix}-nic1"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ip-configuration1"
    subnet_id                     = azurerm_subnet.vnet1_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip1.id
  }
  
  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_network_interface_security_group_association" "nsg_nic1" {
  network_interface_id      = azurerm_network_interface.vnet_interface1.id
  network_security_group_id = azurerm_network_security_group.azure_nsg1.id

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_virtual_machine" "azure_vm1" {
  name                  = "${var.prefix}-vm1"
  location              = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name   = azurerm_resource_group.vnetconnection_rg.name
  network_interface_ids = [azurerm_network_interface.vnet_interface1.id]
  vm_size               = var.vm_size
  zones                 = var.availability_zone

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  #### Boot Diagnostics is Enable with managed storage account ########
  boot_diagnostics {
    enabled = true
    storage_uri = ""
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }
  os_profile {
    computer_name  = "${var.computer_name}-1"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = filebase64("custom_data.sh") 
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_data_disk {
    name              = "${var.prefix}-datadisk1"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = var.extra_disk_size_gb
    lun               = 0
    managed_disk_type = "Standard_LRS"
  }
  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

########################################################## Create VNet2 ######################################################################

resource "azurerm_virtual_network" "vnet-2" {
  name                = "VNet2"
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name
  location            = azurerm_resource_group.vnetconnection_rg.location
  address_space       = ["172.20.0.0/16"]
}

resource "azurerm_subnet" "vnet2_subnet" {
  name                 = "Subnet-2"
  resource_group_name  = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name = azurerm_virtual_network.vnet-2.name
  address_prefixes     = ["172.20.1.0/24"]
}

resource "azurerm_virtual_network_peering" "peer_1" {
  name                      = "peer1"
  resource_group_name       = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-2.id
  allow_virtual_network_access = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "peer_2" {
  name                      = "peer2"
  resource_group_name       = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-1.id
  allow_virtual_network_access = true
  use_remote_gateways          = true
}

############################################## Create NSG2 ######################################################

resource "azurerm_network_security_group" "azure_nsg2" {
  name                = "${var.prefix}-nsg2"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name

  security_rule {
    name                       = "azure_nsg21"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "azure_nsg22"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

################################## Public VM2 in VNet2 #####################################################

resource "azurerm_public_ip" "public_ip2" {
  name                = "${var.prefix}-ip2"
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name
  location            = azurerm_resource_group.vnetconnection_rg.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
  zones = var.availability_zone

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_network_interface" "vnet_interface2" {
  name                = "${var.prefix}-nic2"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ip-configuration2"
    subnet_id                     = azurerm_subnet.vnet2_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip2.id
  }

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_network_interface_security_group_association" "nsg_nic2" {
  network_interface_id      = azurerm_network_interface.vnet_interface2.id
  network_security_group_id = azurerm_network_security_group.azure_nsg2.id

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_virtual_machine" "azure_vm2" {
  name                  = "${var.prefix}-vm2"
  location              = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name   = azurerm_resource_group.vnetconnection_rg.name
  network_interface_ids = [azurerm_network_interface.vnet_interface2.id]
  vm_size               = var.vm_size
  zones                 = var.availability_zone

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  #### Boot Diagnostics is Enable with managed storage account ########
  boot_diagnostics {
    enabled = true
    storage_uri = ""
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }
  os_profile {
    computer_name  = "${var.computer_name}-2"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = filebase64("custom_data.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_data_disk {
    name              = "${var.prefix}-datadisk2"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = var.extra_disk_size_gb
    lun               = 0
    managed_disk_type = "Standard_LRS"
  }
  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

########################################################## Create VNet3 ######################################################################

resource "azurerm_virtual_network" "vnet-3" {
  name                = "VNet3"
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name
  location            = azurerm_resource_group.vnetconnection_rg.location
  address_space       = ["172.21.0.0/16"]
}

resource "azurerm_subnet" "vnet3_subnet" {
  name                 = "Subnet-3"
  resource_group_name  = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name = azurerm_virtual_network.vnet-3.name
  address_prefixes     = ["172.21.1.0/24"]
}

resource "azurerm_virtual_network_peering" "peer_3" {
  name                      = "peer3"
  resource_group_name       = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-3.id
  allow_virtual_network_access = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "peer_4" {
  name                      = "peer4"
  resource_group_name       = azurerm_resource_group.vnetconnection_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-3.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-1.id
  allow_virtual_network_access = true
  use_remote_gateways          = true
}

############################################## Create NSG 3 ######################################################

resource "azurerm_network_security_group" "azure_nsg3" {
  name                = "${var.prefix}-nsg3"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name

  security_rule {
    name                       = "azure_nsg31"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "azure_nsg32"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

################################## Public VM3 in VNet3 #####################################################

resource "azurerm_public_ip" "public_ip3" {
  name                = "${var.prefix}-ip3"
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name
  location            = azurerm_resource_group.vnetconnection_rg.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard
  zones = var.availability_zone

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_network_interface" "vnet_interface3" {
  name                = "${var.prefix}-nic3"
  location            = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name = azurerm_resource_group.vnetconnection_rg.name

  ip_configuration {
    name                          = "${var.prefix}-ip-configuration3"
    subnet_id                     = azurerm_subnet.vnet3_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip3.id
  }

  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_network_interface_security_group_association" "nsg_nic3" {
  network_interface_id      = azurerm_network_interface.vnet_interface3.id
  network_security_group_id = azurerm_network_security_group.azure_nsg3.id

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}

resource "azurerm_virtual_machine" "azure_vm3" {
  name                  = "${var.prefix}-vm3"
  location              = azurerm_resource_group.vnetconnection_rg.location
  resource_group_name   = azurerm_resource_group.vnetconnection_rg.name
  network_interface_ids = [azurerm_network_interface.vnet_interface3.id]
  vm_size               = var.vm_size
  zones                 = var.availability_zone

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  #### Boot Diagnostics is Enable with managed storage account ########
  boot_diagnostics {
    enabled = true
    storage_uri = ""
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }
  os_profile {
    computer_name  = "${var.computer_name}-3"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = filebase64("custom_data.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_data_disk {
    name              = "${var.prefix}-datadisk3"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = var.extra_disk_size_gb
    lun               = 0
    managed_disk_type = "Standard_LRS"
  }
  tags = {
    environment = var.env
  }

  depends_on = [azurerm_virtual_network_gateway.vnetgtw]

}
