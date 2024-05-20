###############################################EC2 in VPC-1###################################################
resource "aws_instance" "ec2_1" {
  ami           = var.provide_ami
  instance_type = var.instance_type
  monitoring = true
  vpc_security_group_ids = [aws_security_group.all_traffic1.id]
  subnet_id = aws_subnet.public_subnet1[0].id 
  root_block_device{
    volume_type="gp2"
    volume_size="20"
    encrypted=true
    kms_key_id = var.kms_key_id 
    delete_on_termination=true
  }
  user_data = file("user_data.sh")
         
  lifecycle{
    prevent_destroy=false
    ignore_changes=[ ami ]
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  metadata_options { #Enabling IMDSv2
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 2
  }

  tags={
    Name="${var.name}-1"
    Environment = var.env
  }
}
resource "aws_eip" "eip_associate1" {
  domain = "vpc"     ###vpc = true
} 
resource "aws_eip_association" "eip_association1" {  ### I will use this EC2 behind the ALB.
  instance_id   = aws_instance.ec2_1.id
  allocation_id = aws_eip.eip_associate1.id
}

#################################EC2 in VPC-2###################################################

resource "aws_instance" "ec2_2" {
  ami           = var.provide_ami
  instance_type = var.instance_type
  monitoring = true
  vpc_security_group_ids = [aws_security_group.all_traffic2.id]
  subnet_id = aws_subnet.public_subnet2[0].id
  root_block_device{
    volume_type="gp2"
    volume_size="20"
    encrypted=true
    kms_key_id = var.kms_key_id
    delete_on_termination=true
  }
  user_data = file("user_data.sh")

  lifecycle{
    prevent_destroy=false
    ignore_changes=[ ami ]
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  metadata_options { #Enabling IMDSv2
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 2
  }

  tags={
    Name="${var.name}-2"
    Environment = var.env
  }
}
resource "aws_eip" "eip_associate2" {
  domain = "vpc"     ###vpc = true
}
resource "aws_eip_association" "eip_association2" {  ### I will use this EC2 behind the ALB.
  instance_id   = aws_instance.ec2_2.id
  allocation_id = aws_eip.eip_associate2.id
}
