module "site2site_vpn_gtw" {
  source = "../module"
  prefix = var.prefix
  outbound_public_ip_vpn_gtw_tunnet_1 = var.outbound_public_ip_vpn_gtw_tunnet_1
  outbound_public_ip_vpn_gtw_tunnet_2 = var.outbound_public_ip_vpn_gtw_tunnet_2
  virtual_network_gateway_id          = var.virtual_network_gateway_id 
  aws_vpc_cidr = var.aws_vpc_cidr
  shared_key_1 = var.shared_key_1
  shared_key_2 = var.shared_key_2
  
  env = var.env[0]

}
