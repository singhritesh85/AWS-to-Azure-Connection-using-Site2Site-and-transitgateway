# AWS-to-Azure-Connection-using-Site2Sitevpn-and-transitgateway
### Architechture Diagram for AWS Transit Gateways
![image](https://github.com/singhritesh85/AWS-to-Azure-Connection-using-Site2Sitevpn-and-transitgateway/assets/56765895/c40dacc1-e691-473b-b6f2-c9a0e5f13262)
### Architechture Diagram for VPN Gateway Transit using Virtual Network Peering
![image](https://github.com/singhritesh85/AWS-to-Azure-Connection-using-Site2Sitevpn-and-transitgateway/assets/56765895/593371c9-d6ca-4fb6-9a69-0a57254c8164)
### Architechure Diagram for Connection between AWS and Azure using Site-to-Site VPN and Transit Gateway
![image](https://github.com/singhritesh85/AWS-to-Azure-Connection-using-Site2Sitevpn-and-transitgateway/assets/56765895/42c207d5-b4b7-4a06-869b-71a7ace5aac3)
<br><br/>
#### Configuration in Azure
1. Create a Resource Group in Azure
```
Resource Group Name: mederma-rg
Region: East US
```
2. Create three VNets in Azure
```
Resource Group Name: mederma-rg
Region: East US
VNet Name: VNet1
VNet IPv4 Address Space(CIDR): 172.19.0.0/16
Subnet Name: Subnet-1
Subnet IPv4 Address Space(CIDR): 172.19.1.0/24
GatewaySubnet with Address Space(CIDR): 172.19.2.0/24

VNet Name: VNet2
VNet IPv4 Address Space(CIDR): 172.20.0.0/16
Subnet Name: Subnet-2
Subnet IPv4 Address Space(CIDR): 172.20.1.0/24

VNet Name: VNet3
VNet IPv4 Address Space(CIDR): 172.21.0.0/16
Subnet Name: Subnet-3
Subnet IPv4 Address Space(CIDR): 172.21.1.0/24


Create three Azure VMs (named as VM1, VM2 and VM3) in these three created subnets
```
3. Create a VPN Gateway using VNet1
```
VPN Gateway Name: VNGTW
Region: East US
Gateway Type: VPN
SKU: VpnGw2
Generation: Generation 2
Virtual Network: VNet1
Public IP Address: VNGTW1-ip-1
Public IP Address Type: Standard
Assignment: Static
Enable active-active mode: Disabled
Configure BGP: Disabled
```
4. Establish VNet Peering between VNet1 and VNet2, VNet1 and VNet3
```
Between VNet1 and VNet2
This virtual network peering link name (for VNet1): peer-1
Allow gateway or route server in 'VNet1' to forward traffic to 'VNet2'

Remote virtual network Peering link name: peer-2
Select the Virtual network as VNet2
Enable 'VNet2' to use 'VNet1's' remote gateway or route server



Between VNet1 and VNet3
This virtual network peering link name (for VNet1): peer-3
Allow gateway or route server in 'VNet1' to forward traffic to 'VNet3'

Remote virtual network Peering link name: peer-4
Select the Virtual network as VNet3
Enable 'VNet3' to use 'VNet1's' remote gateway or route server
```

#### Configuration in AWS
5. Creation of two Virtual Private Cloud (VPC) in AWS
```
Name: VPC-1
IPv4 CIDR: 10.10.0.0/16

Name: VPC-2
IPv4 CIDR: 10.20.0.0/16
```
6. Creation of six subnets inside the VPC-1 (Virtual Network), Route table, Internet-Gateway and six subnets inside the VPC-2 (Virtual Network), Route table, Internet-Gateway
```
Name: PrivateSubnet-11
VPC Name: VPC-1
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.1.0/24


Name: PrivateSubnet-12
VPC Name: VPC-1
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.2.0/24


Name: PrivateSubnet-13
VPC Name: VPC-1
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.3.0/24


Name: PublicSubnet-14
VPC Name: VPC-1
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.4.0/24


Name: PublicSubnet-15
VPC Name: VPC-1
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.5.0/24


Name: PublicSubnet-16
VPC Name: VPC-1
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.6.0/24


Internet Gateway Name: IGW-1
Attach Internet Gateway to VPC-1


create a private route table and public route table named as PrivateRT-1 and PublicRT-1.
Associate three public subnets to Public Route table and three private subnets to Private Route Table. Associate created Internet Gateway to Public Route Table with Destination: 0.0.0.0/0 and Target: Internet Gateway that was created earlier
Destination: 0.0.0.0/0
Target: Internet Gateway that was created earlier

Create an EC2 Instance in Public Subnet, PublicSubnet-11.





Name: PrivateSubnet-21
VPC Name: VPC-2
VPC IPv4 CIDR: 10.20.0.0/16
IPv4 CIDR: 10.20.1.0/24


Name: PrivateSubnet-22
VPC Name: VPC-2
VPC IPv4 CIDR: 10.20.0.0/16
IPv4 CIDR: 10.20.2.0/24


Name: PrivateSubnet-23
VPC Name: VPC-2
VPC IPv4 CIDR: 10.20.0.0/16
IPv4 CIDR: 10.20.3.0/24


Name: PublicSubnet-24
VPC Name: VPC-2
VPC IPv4 CIDR: 10.20.0.0/16
IPv4 CIDR: 10.20.4.0/24


Name: PublicSubnet-25
VPC Name: VPC-2
VPC IPv4 CIDR: 10.20.0.0/16
IPv4 CIDR: 10.20.5.0/24


Name: PublicSubnet-26
VPC Name: VPC-2
VPC IPv4 CIDR: 10.20.0.0/16
IPv4 CIDR: 10.20.6.0/24


Internet Gateway Name: IGW-2
Attach Internet Gateway to VPC-2


create a private route table and public route table named as PrivateRT-2 and PublicRT-2.
Associate three public subnets to Public Route table and three private subnets to Private Route Table. Associate created Internet Gateway to Public Route Table with Destination: 0.0.0.0/0 and Target: Internet Gateway that was created earlier
Destination: 0.0.0.0/0
Target: Internet Gateway that was created earlier

Create an EC2 Instance in Public Subnet, PublicSubnet-21.

```
7. Create Transit Gateway and Transit Gateway Attachments 
```
Create transit gateway 
Transit Gateway Name: TG-01

Transit gateway attachment
Name: TG-Attachment-01
Transit Gateway ID: Transit Gateway create earlier
Attachment Type: VPC
Select the VPC ID for VPC-1

Transit gateway attachment
Name: TG-Attachment-02
Transit Gateway ID: Transit Gateway create earlier
Attachment Type: VPC
Select the VPC ID for VPC-2

Entry corresponding to these Transit Gateway Attachments will be created in Transit Gateway Route Table's Route. 
```

8. Create a customer gateway in AWS pointing to the Public IP Address of Azure VPN Gateway
```
IP address: Public IP Address of the Azure VPN Gateway
Rest other configuration as default
```

9. Create a site-to-site VPN Connection in AWS
```
Name: mederma-site2site
Target gateway type: Transit Gateway (Select the Transit gateway created earlier)
Customer gateway: Existing (Select Customer gateway created earlier)
Routing options: Static
Leave rest of the configuration as default

After Creation of AWS VPN Connection (site-to-site), check a Transit Gateway Attachment for VPN will be created automatically.
```
10. Download the configuration file from AWS Console of Site-to-Site VPN
```
Vendor: Generic
Platform: Generic
Software: Vendor Agnostic
In this configuration file you will note that there are the Shared Keys and the Outside IP Address of Virtual Private Gateway for each of the two IPSec tunnels created by AWS.
```
#### Establishing connection between Azure and AWS
11. Creation of two Local Network Gateway in Azure for two Tunnels
```
Name: mederma-lngtw-1
Resource Group Name: mederma-rg
Region: East US
IP address: Outside IP address from the configuration file downloaded from AWS site-to-site VPN console for Tunnel-1.
Address Space(s): 10.10.0.0/16 and 10.20.0.0/16


Name: mederma-lngtw-2
Resource Group Name: mederma-rg
Region: East US
IP address: Outside IP address from the configuration file downloaded from AWS site-to-site VPN console for Tunnel-2.
Address Space(s): 10.10.0.0/16 and 10.20.0.0/16
```
12. Create two connections in Virtual Network Gateway in Azure for two tunnels
```
Name: mederma-connection1
Connection Type: Site-to-Site
Local Network Gateway: Select the Local Network Gateway which you created earlier.
Shared Key: Get the Shared Key from the configuration file downloaded earlier from AWS Console for VPN site-to-site.
Wait till the Connection Status changed to Connected.
Now check in AWS Console wheather the 1st tunnel of Virtual Private Gateway became UP or not.


Name: mederma-connection2
Connection Type: Site-to-Site
Local Network Gateway: Select the Local Network Gateway which you created earlier.
Shared Key: Get the Shared Key from the configuration file downloaded earlier from AWS Console for VPN site-to-site.
Wait till the Connection Status changed to Connected.
Now check in AWS Console wheather the 2nd tunnel of Virtual Private Gateway became UP or not.
```
13. Now edit the route table associated with created Virtual Private Clouds (VPCs) and route of the Route Table associated with Transit Gateway
```
Do the entry in route of the Route Table of VPC-1 for Azure Subnet through the Virtual Private Gateway
Destination: 172.19.0.0/24
Target: Transit Gateway that we created earlier.
Destination: 172.20.0.0/24
Target: Transit Gateway that we created earlier.
Destination: 172.21.0.0/24
Target: Transit Gateway that we created earlier.
Destination: 10.20.0.0/24
Target: Transit Gateway that we created earlier.


Do the entry in route of the Route Table of VPC-2 for Azure Subnet through the Virtual Private Gateway
Destination: 172.19.0.0/24
Target: Transit Gateway that we created earlier.
Destination: 172.20.0.0/24
Target: Transit Gateway that we created earlier.
Destination: 172.21.0.0/24
Target: Transit Gateway that we created earlier.
Destination: 10.10.0.0/24
Target: Transit Gateway that we created earlier.


Do the entry in route of the Route Table associated with Transit Gateway
CIDR: 172.19.0.0/24
Attachment: Transit Gateway Attachment that was created automatically after creation of AWS VPN Site-to-Site Connection.
Type: Active

CIDR: 172.20.0.0/24
Attachment: Transit Gateway Attachment that was created automatically after creation of AWS VPN Site-to-Site Connection.
Type: Active

CIDR: 172.21.0.0/24
Attachment: Transit Gateway Attachment that was created automatically after creation of AWS VPN Site-to-Site Connection.
Type: Active
```
Finally ping the Private IPs of Azure VM from EC2 and EC2 from Azure VM, Azure VM from Azure VM (in differnet VNet) and EC2 from EC2(in different VPC). 
