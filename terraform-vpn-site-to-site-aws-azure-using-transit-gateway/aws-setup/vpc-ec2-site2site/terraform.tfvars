###########Provide Parameters for VPC-1########################

region = "us-east-2"

vpc_cidr1 = "10.10.0.0/16"
private_subnet_cidr1 = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
public_subnet_cidr1 = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
igw_name1 = "test-IGW1"
vpc_name1 = "test-vpc1"

env = ["dev", "stage", "prod"]

###########Provide Parameters for VPC-2########################

vpc_cidr2 = "10.20.0.0/16"
private_subnet_cidr2 = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
public_subnet_cidr2 = ["10.20.4.0/24", "10.20.5.0/24", "10.20.6.0/24"]
igw_name2 = "test-IGW2"
vpc_name2 = "test-vpc2"


##############################Parameters to launch EC2#############################

instance_count = 1
provide_ami = {
  "us-east-1" = "ami-0a1179631ec8933d7"
  "us-east-2" = "ami-080e449218d4434fa"
  "us-west-1" = "ami-0e0ece251c1638797"
  "us-west-2" = "ami-086f060214da77a16"
}
instance_type = [ "t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge" ]
name = "Instance"

kms_key_id = "arn:aws:kms:us-east-2:02XXXXXXXXXXX6:key/dXXXXXXXXX3-9XX4-4XX4-bXXb-8XXXXXXXXXX9"   ### Provide the ARN of KMS Key.

######################Parameters for AWS Site-to-Site VPN##########################

ip_address_azure_vpn_gtw = "13.82.229.138"                   ### Provide Public IP Address of Azure VPN Gateway
azure_vnet_subnet_cidr_block = ["172.19.1.0/24", "172.20.1.0/24", "172.19.1.0/24"]               ### Provide Azure VNet Subnet CIDR block 
