resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
     }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "EKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks-cluster-role.name

}

resource "aws_iam_role_policy_attachment" "EKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster-role.name
}


resource "aws_eks_cluster" "aws_eks_demo" {
  name     = "eks_cluster_demo"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = [ aws_subnet.public-us-east-1a.id, 
                   aws_subnet.public-us-east-1b.id, 
                   aws_subnet.private-us-east-1a.id, 
                   aws_subnet.private-us-east-1b.id ]
  }

  tags = {
    Name = "eks_demo"
  }
}

resource "aws_iam_role" "eks-nodes-role" {
  name = "eks-nodes-role"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "EKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-nodes-role.name
}

resource "aws_iam_role_policy_attachment" "EKS-CNI-Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-nodes-role.name

}

resource "aws_iam_role_policy_attachment" "EC2-ContainerRegistyReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-nodes-role.name

}

resource "aws_eks_node_group" "nodes" {
  cluster_name = aws_eks_cluster.aws_eks_demo.name
  node_group_name = "ngp-1"
  node_role_arn = aws_iam_role.eks-nodes-role.arn
  subnet_ids = [ aws_subnet.private-us-east-1a.id, 
                 aws_subnet.private-us-east-1b.id ]

  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1

  }

  depends_on = [
    aws_iam_role_policy_attachment.EKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.EKS-CNI-Policy,
    aws_iam_role_policy_attachment.EC2-ContainerRegistyReadOnly,
  ]
}