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
    availability_zone = "us-east-1a"

    tags = {
        Name = "public-us-east-1a"
    }
}
resource "aws_subnet" "public-us-east-1b" {
    vpc_id = aws_vpc.eks-main.id
    cidr_block = "10.0.16.0/20"
    availability_zone = "us-east-1b"

    tags = {
        Name = "public-us-east-1b"
    }
}
resource "aws_subnet" "private-us-east-1a" {
    vpc_id = aws_vpc.eks-main.id
    cidr_block = "10.0.32.0/20"
    availability_zone = "us-east-1a"

    tags = {
        Name = "private-us-east-1a"
    }
}
resource "aws_subnet" "private-us-east-1b" {
    vpc_id = aws_vpc.eks-main.id
    cidr_block = "10.0.48.0/20"
    availability_zone = "us-east-1b"

    tags = {
        Name = "private-us-east-1b"
    }
}

# Create Route table for puvblic subnets

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.eks-main.id
     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks-igw.id
     }
}

# Create Route table for private subnets

resource "aws_route_table" "private-rt-1" {
    vpc_id = aws_vpc.eks-main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.eks-ngw-1.id
    }
}

resource "aws_route_table" "private-rt-2" {
    vpc_id = aws_vpc.eks-main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.eks-ngw-2.id
    }
}

# Assign route tables to subnets

resource "aws_route_table_association" "public-1" {
    subnet_id = aws_subnet.public-us-east-1a.id 
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-2" {
    subnet_id = aws_subnet.public-us-east-1b.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-1" {
    subnet_id = aws_subnet.private-us-east-1a.id
    route_table_id = aws_route_table.private-rt-1.id
}

resource "aws_route_table_association" "private-2" {
    subnet_id =  aws_subnet.private-us-east-1b.id
    route_table_id = aws_route_table.private-rt-2.id
}