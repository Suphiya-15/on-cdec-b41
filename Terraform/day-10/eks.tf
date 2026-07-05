
#how to create cluster:
#1. create IAMrole for cluster
#amazoneksservicerolepolicy

#2. create cluster
#cluster-name
#IAM policy
#vpc and subnet

#3. create IAMpolicy for node group
#amazonEKSCNIpolicy
#amazonec2containerregisteryreadonly
#amazoneksworkernodepolicy


#4. create node group
#name
#iam policy
#instance configuration

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "cbz-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
    role = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  
  
}
data "aws_vpc" "my_vpc" {
    default = true
  
}

data "aws_subnets" "my_subnet" {
    filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my_vpc.id]
  }
  
}

resource "aws_eks_cluster" "my_cluster" {
    name = "my-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn
    vpc_config {
      subnet_ids = data.aws_subnets.my_subnet.ids
    }
  depends_on = [ aws_iam_role_policy_attachment.cluster_policy_attachment ]
}

resource "aws_iam_role" "node_role" {
    name = "cbz-node-role"
    assume_role_policy =  jsonencode({

  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
    })

}

resource "aws_iam_role_policy_attachment" "eks_cni_cluster_policy" {
    role = aws_iam_role.node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
   
}
resource "aws_iam_role_policy_attachment" "eks_registry_cluster_policy" {
    role = aws_iam_role.node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
   
}
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
    role = aws_iam_role.node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
   
}
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "node-group"
  node_role_arn   = aws_iam_role.node_role.arn

  subnet_ids = data.aws_subnets.my_subnet.ids

  instance_types = ["t3.micro"]
  disk_size      = 20

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_cluster_policy,
    aws_iam_role_policy_attachment.eks_registry_cluster_policy
  ]
}

