############################### Create VPC-1 #######################################

resource "aws_vpc" "test_vpc1" {
  cidr_block       = "${var.vpc_cidr1}"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name1}-${var.env}"                     ##"test-vpc"
    Environment = var.env            ##"${terraform.workspace}"
  }
}

############################### Create VPC-2 #######################################

resource "aws_vpc" "test_vpc2" {
  cidr_block       = "${var.vpc_cidr2}"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name2}-${var.env}"                     ##"test-vpc"
    Environment = var.env            ##"${terraform.workspace}"
  }
}

############################### Public Subnet for VPC-1 ##########################################

resource "aws_subnet" "public_subnet1" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id     = "${aws_vpc.test_vpc1.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block = "${element(var.public_subnet_cidr1,count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${var.env}-${count.index+11}"
    Environment = var.env            ##"${terraform.workspace}"
  }
}

############################### Public Subnet for VPC-2 ##########################################

resource "aws_subnet" "public_subnet2" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id     = "${aws_vpc.test_vpc2.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block = "${element(var.public_subnet_cidr2,count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${var.env}-${count.index+21}"
    Environment = var.env            ##"${terraform.workspace}"
  }
}

############################### Private Subnet for VPC-1 #########################################

resource "aws_subnet" "private_subnet1" {
  count = "${length(data.aws_availability_zones.azs.names)}"                  ##"${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"
  vpc_id     = "${aws_vpc.test_vpc1.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block = "${element(var.private_subnet_cidr1,count.index)}"

  tags = {
    Name = "PrivateSubnet-${var.env}-${count.index+11}"
    Environment = var.env                ##"${terraform.workspace}"
  }
}

############################### Private Subnet for VPC-2 #########################################

resource "aws_subnet" "private_subnet2" {
  count = "${length(data.aws_availability_zones.azs.names)}"                  ##"${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"
  vpc_id     = "${aws_vpc.test_vpc2.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block = "${element(var.private_subnet_cidr2,count.index)}"

  tags = {
    Name = "PrivateSubnet-${var.env}-${count.index+21}"
    Environment = var.env                ##"${terraform.workspace}"
  }
}

############################### Public Route Table for VPC-1 ####################################

resource "aws_route_table" "public_route_table1" {
  vpc_id = aws_vpc.test_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIGW1.id
  }

  tags = {
    Name = "public-route-table-${var.env}-1"
    Environment = var.env              ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public_route_table_association1" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  subnet_id      = aws_subnet.public_subnet1[count.index].id
  route_table_id = aws_route_table.public_route_table1.id
}

############################### Public Route Table for VPC-2 ####################################

resource "aws_route_table" "public_route_table2" {
  vpc_id = aws_vpc.test_vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIGW2.id
  }

  tags = {
    Name = "public-route-table-${var.env}-2"
    Environment = var.env              ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public_route_table_association2" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  subnet_id      = aws_subnet.public_subnet2[count.index].id
  route_table_id = aws_route_table.public_route_table2.id
}


############################### Default Route Table for VPC-1 ###################################

resource "aws_default_route_table" "default_route_table1" {
  default_route_table_id = aws_vpc.test_vpc1.default_route_table_id

   tags = {
    Name = "default-route-table-${var.env}-1"
    Environment = var.env               ##"${terraform.workspace}"
  }

}

############################### Default Route Table for VPC-2 ###################################

resource "aws_default_route_table" "default_route_table2" {
  default_route_table_id = aws_vpc.test_vpc2.default_route_table_id

   tags = {
    Name = "default-route-table-${var.env}-2"
    Environment = var.env               ##"${terraform.workspace}"
  }

}

############################### Private Route Table for VPC-1 ###################################

resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.test_vpc1.id

  tags = {
    Name = "Private-route-table-${var.env}-1"
   Environment = var.env                  ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "private_route_table_association1" {
  count = "${length(data.aws_availability_zones.azs.names)}"                        ##"${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"
  subnet_id      = aws_subnet.private_subnet1[count.index].id                                   ##aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_route_table1.id
}

############################### Private Route Table for VPC-2 ###################################

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.test_vpc2.id

  tags = {
    Name = "Private-route-table-${var.env}-2"
   Environment = var.env                  ##"${terraform.workspace}"
  }
}

resource "aws_route_table_association" "private_route_table_association2" {
  count = "${length(data.aws_availability_zones.azs.names)}"                        ##"${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"
  subnet_id      = aws_subnet.private_subnet2[count.index].id                                   ##aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_route_table2.id
}

############################################# Internet Gateway for VPC-1 ####################################################

resource "aws_internet_gateway" "testIGW1" {
  
  vpc_id = aws_vpc.test_vpc1.id

  tags = {
    Name = "${var.igw_name1}-${var.env}-1"        #"test-IGW"
    Environment = var.env               ##"${terraform.workspace}"
  }
}

############################################# Internet Gateway for VPC-2 ####################################################

resource "aws_internet_gateway" "testIGW2" {

  vpc_id = aws_vpc.test_vpc2.id

  tags = {
    Name = "${var.igw_name2}-${var.env}-2"        #"test-IGW"
    Environment = var.env               ##"${terraform.workspace}"
  }
}
 
############################################ Security Group for VPC-1 to Allow All Traffic #############################

resource "aws_security_group" "all_traffic1" {
 name        = "AllTraffic-Security-Group-${var.env}-1"
 description = "Allow All Traffic"
 vpc_id      = aws_vpc.test_vpc1.id

ingress {
   description = "Allow All Traffic"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

############################################ Security Group for VPC-2 to Allow All Traffic #############################

resource "aws_security_group" "all_traffic2" {
 name        = "AllTraffic-Security-Group-${var.env}-2"
 description = "Allow All Traffic"
 vpc_id      = aws_vpc.test_vpc2.id

ingress {
   description = "Allow All Traffic"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
