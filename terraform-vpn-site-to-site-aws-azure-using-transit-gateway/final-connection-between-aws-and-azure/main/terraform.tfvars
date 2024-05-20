#################### Parameters for LOcal Network Gateway and Virtual Network Gateway Connection #########################

prefix = "mederma"
outbound_public_ip_vpn_gtw_tunnet_1 = "3.138.242.202"   ### Provide the Outbound Public IP for Virtual Network Gateway for Tunnet 1
outbound_public_ip_vpn_gtw_tunnet_2 = "18.221.208.50"   ### Provide the Outbound Public IP for Virtual Network Gateway for Tunnet 2
aws_vpc_cidr = ["10.10.0.0/16", "10.20.0.0/16"]
shared_key_1 = "LXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXa"     ### Provide the Shared Key from Dowloaded configuration file for Tunnel 1
shared_key_2 = "rXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXa"     ### Provide the Shared Key from Dowloaded configuration file for Tunnel 2
virtual_network_gateway_id = "/subscriptions/51283936-af44-49c6-9a24-f1cbdc17915d/resourceGroups/mederma-rg/providers/Microsoft.Network/virtualNetworkGateways/mederma-VNGTW"

env = ["dev", "stage", "prod"]
