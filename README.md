# AWS-to-Azure-Connection-using-Site2Sitevpn-and-transitgateway
### Architechture Diagram for AWS Transit Gateways
![image](https://github.com/singhritesh85/AWS-to-Azure-Connection-using-Site2Sitevpn-and-transitgateway/assets/56765895/c40dacc1-e691-473b-b6f2-c9a0e5f13262)
### Architechture Diagram for VPN Gateway Transit using Virtual Network Peering
![image](https://github.com/singhritesh85/AWS-to-Azure-Connection-using-Site2Sitevpn-and-transitgateway/assets/56765895/593371c9-d6ca-4fb6-9a69-0a57254c8164)
<br><br/>
#### Configuration in Azure
1. Create a Resource Group in Azure
```
Resource Group Name: mederma-rg
Region: East US
```
2. Create VNet in Azure
```
Resource Group Name: mederma-rg
Region: East US
VNet Name: mederma-vnet1
VNet IPv4 Address Space(CIDR): 172.19.0.0/16
Subnet Name: mederma-vnet1subnet
Subnet IPv4 Address Space(CIDR): 172.19.1.0/24
GatewaySubnet with Address Space(CIDR): 172.19.2.0/24


Create a Azure VM in this created subnet
```
3. Create VPN Gateway
```
VPN Gateway Name: mederma-VNGTW
Region: East US
Gateway Type: VPN
SKU: VpnGw2
Generation: Generation 2
Virtual Network: mederma-vnet1
Public IP Address: mederma-VNGTW1-ip
Public IP Address Type: Standard
Assignment: Static
Enable active-active mode: Disabled
Configure BGP: Disabled
```
#### Configuration in AWS
4. Creation of Virtual Private Cloud (VPC) in VPC
```
Name: test-vpc-dev
IPv4 CIDR: 10.10.0.0/16
```
5. Creation of six subnets inside the VPC (Virtual Network), Route table, Internet-Gateway
```
Name: PrivateSubnet-dev-1
VPC Name: test-vpc-dev
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.1.0/24


Name: PrivateSubnet-dev-2
VPC Name: test-vpc-dev
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.2.0/24


Name: PublicSubnet-dev-3
VPC Name: test-vpc-dev
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.3.0/24


Name: PublicSubnet-dev-1
VPC Name: test-vpc-dev
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.4.0/24


Name: PublicSubnet-dev-2
VPC Name: test-vpc-dev
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.5.0/24


Name: PublicSubnet-dev-3
VPC Name: test-vpc-dev
VPC IPv4 CIDR: 10.10.0.0/16
IPv4 CIDR: 10.10.6.0/24


Internet Gateway Name: test-IGW
Attach Internet Gateway to VPC


create a private route table and public route table named as private-route-table-dev and public-route-table-dev.
Associate three public subnets to Public Route table and three private subnets to Private Route Table. Associate created Internet Gateway to Public Route Table with Destination: 0.0.0.0/0 and Target: Internet Gateway that was created earlier
Destination: 0.0.0.0/0
Target: Internet Gateway that was created earlier


Create an EC2 Instance in Public Subnet.
```
6. Create a customer gateway in AWS pointing to the Public IP Address of Azure VPN Gateway
```
IP address: Public IP Address of the Azure VPN Gateway
Rest other configuration as default
```
7. Create Virtual Private Gateway then attach to the AWS Virtual Private Cloud (VPC)
```
Name: mederma-virtual-private-gtw
```
8. Create a site-to-site VPN Connection in AWS
```
Name: mederma-site2site
Target gateway type: Virtual private gateway (Select the Virtual private gateway created earlier)
Customer gateway: Existing (Select Customer gateway created earlier)
Routing options: Static
Static IP prefixes: 172.19.1.0/24  (Azure VNet Subnet created earlier)
Leave rest of the configuration as default
```
9. Download the configuration file from AWS Console of Site-to-Site VPN
```
Vendor: Generic
Platform: Generic
Software: Vendor Agnostic
In this configuration file you will note that there are the Shared Keys and the Outside IP Address of Virtual Private Gateway for each of the two IPSec tunnels created by AWS.
```
#### Establishing connection between Azure and AWS
10. Creation of two Local Network Gateway in Azure for two Tunnels
```
Name: mederma-lngtw-1
Resource Group Name: mederma-rg
Region: East US
IP address: Outside IP address from the configuration file downloaded from AWS site-to-site VPN console for Tunnel-1.
Address Space(s): 10.10.0.0/16


Name: mederma-lngtw-2
Resource Group Name: mederma-rg
Region: East US
IP address: Outside IP address from the configuration file downloaded from AWS site-to-site VPN console for Tunnel-2.
Address Space(s): 10.10.0.0/16
```
11. Create two connections in Virtual Network Gateway in Azure for two tunnels
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
12. Now edit the route table associated with created Virtual Private Cloud (VPC)
```
Do the entry in route of the Route Table of VPC for Azure Subnet through the Virtual Private Gateway
Destination: 172.19.1.0/24
Target: Virtual Private Gateway that we created earlier.
```
Finally ping the two Private IPs of Azure VM from EC2 and EC2 from from Azure VM. 
