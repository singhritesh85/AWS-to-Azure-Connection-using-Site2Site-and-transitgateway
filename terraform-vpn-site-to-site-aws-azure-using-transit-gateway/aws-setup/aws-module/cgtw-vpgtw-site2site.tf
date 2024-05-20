########################################## Customer Gateway ###############################################

resource "aws_customer_gateway" "customer_gtw" {
  bgp_asn    = 65000
  ip_address = var.ip_address_azure_vpn_gtw               ### Public IP Address of the Azure VPN Gateway
  type       = "ipsec.1"

  tags = {
    Name = "${var.vpc_name1}-${var.vpc_name2}-customer-gateway"
  }
}

############################################# Transit Gateway #############################################

resource "aws_ec2_transit_gateway" "TGW" {
  description                     = "transit gateway"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "TGW-01"
  }
}

############################################## Transit Gateway Attachment1 #################################

resource "aws_ec2_transit_gateway_vpc_attachment" "TG_Attachment_01" {
  subnet_ids         = [aws_subnet.private_subnet1[0].id, aws_subnet.private_subnet1[1].id, aws_subnet.public_subnet1[2].id]
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  vpc_id             = aws_vpc.test_vpc1.id

  tags = {
    Name = "TG-Attachment-01"
    Environment = var.env
  }
}

############################################## Transit Gateway Attachment2 #################################

resource "aws_ec2_transit_gateway_vpc_attachment" "TG_Attachment_02" {
  subnet_ids         = [aws_subnet.private_subnet2[0].id, aws_subnet.private_subnet2[1].id, aws_subnet.public_subnet2[2].id]
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  vpc_id             = aws_vpc.test_vpc2.id

  tags = {
    Name = "TG-Attachment-02"
    Environment = var.env
  }
}

######################################### AWS Site-to-Site VPN ############################################

resource "aws_vpn_connection" "site2site_vpn" {
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
  customer_gateway_id = aws_customer_gateway.customer_gtw.id
  type                = "ipsec.1"
  static_routes_only  = true
  
  tags = {
    Name = "${var.vpc_name1}-${var.vpc_name2}-site2site-vpn"
  }
}

################################### Transit Gateway Route Table Association ################################

#data "aws_ec2_transit_gateway_vpn_attachment" "vpn_attachment" {
#  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
#  vpn_connection_id  = aws_vpn_connection.site2site_vpn.id
#}

resource "aws_ec2_transit_gateway_route" "tgw_default_route1" {
  destination_cidr_block         = "172.19.0.0/16"
  transit_gateway_attachment_id  = aws_vpn_connection.site2site_vpn.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.TGW.association_default_route_table_id
  blackhole                      = false
}

resource "aws_ec2_transit_gateway_route" "tgw_default_route2" {
  destination_cidr_block         = "172.20.0.0/16"
  transit_gateway_attachment_id  = aws_vpn_connection.site2site_vpn.transit_gateway_attachment_id  
  transit_gateway_route_table_id = aws_ec2_transit_gateway.TGW.association_default_route_table_id
  blackhole                      = false
}

resource "aws_ec2_transit_gateway_route" "tgw_default_route3" {
  destination_cidr_block         = "172.21.0.0/16"
  transit_gateway_attachment_id  = aws_vpn_connection.site2site_vpn.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.TGW.association_default_route_table_id
  blackhole                      = false
}

########################### Entry in Route of the Route Table of VPC-1 for TG-Attachments and VPC CIDRs ###########################

resource "aws_route" "vpc_route1" {
  route_table_id            = aws_route_table.public_route_table1.id
  destination_cidr_block    = "172.19.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

resource "aws_route" "vpc_route2" {
  route_table_id            = aws_route_table.public_route_table2.id
  destination_cidr_block    = "172.19.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

resource "aws_route" "vpc_route3" {
  route_table_id            = aws_route_table.public_route_table1.id
  destination_cidr_block    = "172.20.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

resource "aws_route" "vpc_route4" {
  route_table_id            = aws_route_table.public_route_table2.id
  destination_cidr_block    = "172.20.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

resource "aws_route" "vpc_route5" {
  route_table_id            = aws_route_table.public_route_table1.id
  destination_cidr_block    = "172.21.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

resource "aws_route" "vpc_route6" {
  route_table_id            = aws_route_table.public_route_table2.id
  destination_cidr_block    = "172.21.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

resource "aws_route" "vpc_route7" {
  route_table_id            = aws_route_table.public_route_table1.id
  destination_cidr_block    = "10.20.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

resource "aws_route" "vpc_route8" {
  route_table_id            = aws_route_table.public_route_table2.id
  destination_cidr_block    = "10.10.0.0/16"
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
}

