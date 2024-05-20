### Connection between AWS and Azure using Site-to-Site VPN

**High Level Architecture Diagram**
<br><br/>
![image](https://github.com/singhritesh85/connect-aws-to-azure-using-site2site-vpn/assets/56765895/0cad0574-9ae8-4d3c-b8b7-7f3d772eecf9)

Using this terraform script it is possible to establish a connection between AWS and Azure. Follow below steps to achieve this. 
```
1. clone this repository using git clone https://github.com/singhritesh85/connect-aws-to-azure-using-site2site-vpn.git
2. cd connect-aws-to-azure-using-site2site-vpn/terraform-vpn-site-to-site-aws-azure/
3. change directory to aws-setup then vpc-ec2-site2site. Then run terraform init and finally run terraform apply -auto-approve.
4. change directory to azure-setup then vpn-gtw. Then run terraform init and finally run terraform apply -auto-approve.
5. change directory to final-connection-between-aws-and-azure then main. Then run terraform init and finally run terraform apply -auto-approve.
```
```
After executing above terraform scripts you have created
(a) Azure Resource-Group, VNet, Subnet in Vnet and GatewaySubnet in VNet, Virtual Network Gateway, Azure VM and NSG.
(b) AWS VPC, Six Subnets(3 Private and 3 Public Subnets), three Route Tables(1 Default Route Table, 1 Private Route Table and 1 Public Route Table), Internet Gateway (attach IGW to Public Route Table), EC2 and Security Group, Customer Gateway, Virtual Private Gateway and VPN Connection (Site-to-Site).
(c) After above step download the Configuration file from AWS Console for VPN Connection and using parameters present in this configuration file perform the further step.
(d) Finally create two Azure Local Network Gateway and two Connections in Azure Virtual Network Gateway.  
```
```
At last associate Azure VNet Subnet CIDR in Route of the created Public and Private Route tables as written below.
Destination: 172.19.1.0/24
Target: Virtual Private Gateway that we created earlier.
```
Now ping the two Private IPs of Azure VM from EC2 and EC2 from from Azure VM.
