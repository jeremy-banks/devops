# data "aws_iam_policy_document" "iam_role_eks_cluster" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:CreateTags"
#     ]
#     resources = ["arn:aws:ec2:*:*:instance/*"]
#     condition {
#       test     = "StringLike"
#       variable = "aws:TagKeys"
#       values = ["kubernetes.io/cluster/*"]
#     }
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeDhcpOptions",
#       "kms:DescribeKey",
#     ]
#     resources = ["*"]
#   }
# }

# module "iam_policy_eks_cluster" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "5.45.0"
#   providers = { aws = aws.sdlc_prd }

#   name        = "eks-cluster"
#   path        = "/"

#   policy = data.aws_iam_policy_document.iam_role_eks_cluster.json
# }

# module "iam_role_eks_cluster" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.45.0"
#   providers = { aws = aws.sdlc_prd }

#   trusted_role_services = [
#     "eks.amazonaws.com"
#   ]

#   create_role = true

#   role_name  = "eks-cluster"
#   role_requires_mfa = false

#   custom_role_policy_arns = [
#     module.iam_policy_eks_cluster.arn
#   ]
# }

# data "aws_iam_policy_document" "iam_role_eks_cluster_services" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeDhcpOptions",
#       "kms:DescribeKey",
#     ]
#     resources = ["*"]
#   }
# }

# module "iam_policy_eks_cluster_services" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "5.45.0"
#   providers = { aws = aws.sdlc_prd }

#   name        = "eks-cluster-services"
#   path        = "/"

#   policy = data.aws_iam_policy_document.iam_role_eks_cluster_services.json
# }

# module "iam_role_eks_cluster_services_node" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.45.0"
#   providers = { aws = aws.sdlc_prd }

#   create_instance_profile = true
#   trusted_role_services = [
#     "ec2.amazonaws.com"
#   ]

#   create_role = true

#   role_name  = "eks-cluster-services-node"
#   role_requires_mfa = false

#   custom_role_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#     "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#     module.iam_policy_eks_cluster_services.arn
#   ]
# }

# data "aws_iam_policy_document" "iam_role_eks_worker_node" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeDhcpOptions",
#       "kms:DescribeKey",
#     ]
#     resources = ["*"]
#   }
# }

# module "iam_policy_eks_worker_node" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "5.45.0"
#   providers = { aws = aws.sdlc_prd }

#   name        = "eks-worker-node"
#   path        = "/"

#   policy = data.aws_iam_policy_document.iam_role_eks_worker_node.json
# }

# module "iam_role_eks_worker_node" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.45.0"
#   providers = { aws = aws.sdlc_prd }

#   create_instance_profile = true
#   trusted_role_services = [
#     "ec2.amazonaws.com"
#   ]

#   create_role = true

#   role_name  = "eks-worker-node"
#   role_requires_mfa = false

#   custom_role_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#     "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#     module.iam_policy_eks_worker_node.arn
#   ]
# }
