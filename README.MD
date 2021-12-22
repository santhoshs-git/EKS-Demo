### EKS Demo using Terraform from scratch

1. VPC and Networking
2. Create EKS cluster
3. Create Managed nodegroup
4. Create Unmanagaed nodegroup

# VPC and Networking
 EKS needs to be deployed into VPC, if you have already one you can use that, else create one. This VPC architecture has total of 4 subnets which spread across 2 availability zones, 2 public and 2 private respectively. If you dont want any public access to your cluster you can have all as private subnet. For high availablity I have used two Nat Gateways and placed one in each public subnet, you can use 1 Nat Gateway as well, if it is for development purpose. In each of the public zone there is one bation host which will be used to make ssh connection to the nodes placed in private subnet.

# Create EKS cluster
 EKS cluster can be created using multiple ways as mentioned below.
1. eksctl
2. AWS console
3. Terraform 
4. Cloudformation