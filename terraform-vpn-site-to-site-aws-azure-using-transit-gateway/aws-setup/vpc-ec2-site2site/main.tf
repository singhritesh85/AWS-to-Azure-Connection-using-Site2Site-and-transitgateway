module "awssite2site" {
  source = "../aws-module"

  vpc_cidr1 = var.vpc_cidr1
  vpc_cidr2 = var.vpc_cidr2
  private_subnet_cidr1 = var.private_subnet_cidr1
  private_subnet_cidr2 = var.private_subnet_cidr2
  public_subnet_cidr1 = var.public_subnet_cidr1
  public_subnet_cidr2 = var.public_subnet_cidr2
  igw_name1 = var.igw_name1
  igw_name2 = var.igw_name2
  vpc_name1 = var.vpc_name1
  vpc_name2 = var.vpc_name2

  env = var.env[0]

###########################To Launch EC2###################################

  instance_count = var.instance_count
  provide_ami = var.provide_ami["us-east-2"]
  instance_type = var.instance_type[0]
  kms_key_id = var.kms_key_id
  name = var.name 

########################## AWS Site-to-Site VPN ############################

  ip_address_azure_vpn_gtw = var.ip_address_azure_vpn_gtw
  azure_vnet_subnet_cidr_block = var.azure_vnet_subnet_cidr_block

}
