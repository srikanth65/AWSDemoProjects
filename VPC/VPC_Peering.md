**AccountA - RegionA(us-east-1) - VPCA - CIDR 10.0.0.0/16**

1. Create VPC with CIDR, Subnets(With auto assign public IP), IGW, NAT, Attach subnets to Main route table and Private Route Table

2. Get AccountA_ID, VPCA_ID, VPCA_CIDR

**AccountB- RegionB(us-west-1) - VPCB - CIDR 10.1.0.0/16**

1. Create VPC with CIDR, Subnets(With auto assign public IP), IGW, NAT, Attach subnets to Main route table and Private Route Table

2. Get AccountB_ID, VPCB_ID, VPCB_CIDR

**Create VPC peering from AccountA**, 

Give details: AccountB, VPCB, RegionB 

Update Main Routetable of AccountA: With 10.1.0.0/16 to PeeringID-B

**Go to AccountB**, 

VPCB - Peering - Accept the Peering Request 

Update Main Routetable of AccountA: With 10.0.0.0/16 to PeeringID-A


**To check connectivity:** 

AccountA - EC2 with PublicIP - SG with ICMP and accept the traffic from 10.1.0.0/16

AccountB - EC2 with PublicIP - SG with ICMP and accept the traffic from 10.0.0.0/16

ping <EC2PrivateIP>
