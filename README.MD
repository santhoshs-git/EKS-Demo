### EKS Demo using Terraform from scratch

1. VPC and Networking
2. Create EKS cluster
3. Create Managed nodegroup
4. Create Unmanagaed nodegroup

# VPC and Networking
 EKS needs to be deployed into VPC, if you have already one you can use that, else create one. This VPC architecture has total of 4 subnets which spread across 2 availability zones, 2 public and 2 private respectively. If you dont want any public access to your cluster you can have all as private subnet. For high availablity I have used two Nat Gateways and placed one in each public subnet, you can use 1 Nat Gateway as well, if it is for development purpose. In each of the public zone there is one bation host which will be used to make ssh connection to the nodes placed in private subnet.

    1. Create VPC with the large or required cidr block.
    2. Create 2 Public subnets and 2 private subnets, which spans in 2 AZ's(us-east-1a & us-east1b) respectively.
    3. Create an Internet Gateway to enable outside world access for our VPC public subnets.
    4. Create 2 Elastic IP's which needed for Nat Gatway.
    5. Create 2 Nat Gatway with the clready created EIP's, each in 1 public subnet.
    6. Create a route table for public subnets, which routes traffic to the Internet Gateway.
    7. Create a route table for private subnets, which routes the traffic to the Nat Gateway.

# EKS cluster
 EKS cluster can be created using multiple ways as mentioned below.
1. eksctl
2. AWS console
3. Terraform 
4. Cloudformation
    
    # Create EKS cluster and Node group using terraform
    1. Create an IAM role resource for EKS cluster with all the required permissions.
    2. Create a EKS cluster resource with created a IAM role and specify the subnets in which it needs to be created.
    3. Create an IAM role for EKS node group with all the required permissions.
    4. Create a Node group and specify the scaling configs and subnets in which it needs to be created, by default it will take t3.medium computes sizewith the Amzon Linux 2 image as nodes.

# Apply the Terraform changes
1. Execute "terraform apply" and review the resources which are going to created, confirm by typing "yes".
2. Verify the cluster and other resources creation in AWS console.
3. Execute "aws eks update-kubeconfig --name <cluster-name> --region <region>" and get the cluster config.
    Try exectuting kubernetes commands:
    1. kubectl get pods # It will list all the running pods in default name sapce.
    2. kubctl get ns # Will list the available namespaces


