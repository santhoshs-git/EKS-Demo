resource "aws_vpc" "eks-main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "eks-v1-demo"
    }
}

# Create Internet Gateway for internet access to public subnet
resource "aws_internet_gateway" "eks-igw" {
    vpc_id = aws_vpc.eks-main.id

    tags = {
        Name = "eks-v1-igw"
    }
}

# Create EIP for Nat Gateway
resource "aws_eip" "eip-ngw" {
    count = "2"
    vpc = true
    depends_on = [aws_internet_gateway.eks-igw]
}

# Create Nat Gateway for private subnets to get Internet access
resource "aws_nat_gateway" "eks-ngw-1" {
    subnet_id = aws_subnet.public-us-east-1a.id
    allocation_id = element(aws_eip.eip-ngw.*.id, 1)

    tags = {
        Name = "eks-v1-ngw-1"
    }
}
resource "aws_nat_gateway" "eks-ngw-2" {
    subnet_id = aws_subnet.public-us-east-1b.id
    allocation_id = element(aws_eip.eip-ngw.*.id, 2)

    tags = {
        Name = "eks-v1-ngw-2"
    }
}
# Create Public and Private SUbnets
resource "aws_subnet" "public-us-east-1a" {
    vpc_id = aws_vpc.eks-main.id
    cidr_block = "10.0.0.0/20"

    tags = {
        Name = "public-us-east-1a"
    }
}
resource "aws_subnet" "public-us-east-1b" {
    vpc_id = aws_vpc.eks-main.id
    cidr_block = "10.0.16.0/20"

    tags = {
        Name = "public-us-east-1b"
    }
}
resource "aws_subnet" "private-us-east-1a" {
    vpc_id = aws_vpc.eks-main.id
    cidr_block = "10.0.32.0/20"

    tags = {
        Name = "private-us-east-1a"
    }
}
resource "aws_subnet" "private-us-east-1b" {
    vpc_id = aws_vpc.eks-main.id
    cidr_block = "10.0.48.0/20"

    tags = {
        Name = "private-us-east-1b"
    }
}