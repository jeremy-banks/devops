# module "role_eks_cluster_service" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.30.1"

#   create_role = true

#   role_name = "${local.resource_name_stub}-eks-cluster-service"

#   trusted_role_arns = [
#     "arn:aws:iam::${var.identity_account_number}:root"
#   ]

#   role_requires_mfa = false

#   role_permissions_boundary_arn = aws_iam_policy.permission_boundary.arn

#   custom_role_policy_arns = [
#     aws_iam_policy.allow_readonly.arn,
#     aws_iam_policy.role_eks_cluster_service.arn
#   ]
#   number_of_custom_role_policy_arns = 2
# }

# resource "aws_iam_policy" "role_eks_cluster_service" {
#   name        = "${local.resource_name_stub}-eks-cluster-service"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Action = [
#           "acm-pca:Describe*",
#           "acm-pca:Get*",
#           "acm-pca:List*",
#           "acm:Describe*",
#           "acm:Get*",
#           "acm:List*",
#         ],
#         Resource = "*",
#       }
#     ]
#   })
# }



# module "role_eks_node_service" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.30.1"

#   create_role = true

#   role_name = "${local.resource_name_stub}-eks-node-service"

#   trusted_role_arns = [
#     "arn:aws:iam::${var.identity_account_number}:root"
#   ]

#   role_requires_mfa = false

#   role_permissions_boundary_arn = aws_iam_policy.permission_boundary.arn

#   custom_role_policy_arns = [
#     aws_iam_policy.allow_readonly.arn,
#     aws_iam_policy.role_eks_node_service.arn
#   ]
#   number_of_custom_role_policy_arns = 2
# }

# resource "aws_iam_policy" "role_eks_node_service" {
#   name        = "${local.resource_name_stub}-eks-node-service"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Action = [
#           "acm-pca:Describe*",
#           "acm-pca:Get*",
#           "acm-pca:List*",
#           "acm:Describe*",
#           "acm:Get*",
#           "acm:List*",
#         ],
#         Resource = "*",
#       }
#     ]
#   })
# }



# module "role_eks_node_worker" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.30.1"

#   create_role = true

#   role_name = "${local.resource_name_stub}-eks-node-worker"

#   trusted_role_arns = [
#     "arn:aws:iam::${var.identity_account_number}:root"
#   ]

#   role_requires_mfa = false

#   role_permissions_boundary_arn = aws_iam_policy.permission_boundary.arn

#   custom_role_policy_arns = [
#     aws_iam_policy.allow_readonly.arn,
#     aws_iam_policy.role_eks_node_worker.arn
#   ]
#   number_of_custom_role_policy_arns = 2
# }

# resource "aws_iam_policy" "role_eks_node_worker" {
#   name        = "${local.resource_name_stub}-eks-node-worker"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Action = [
#           "acm-pca:Describe*",
#           "acm-pca:Get*",
#           "acm-pca:List*",
#           "acm:Describe*",
#           "acm:Get*",
#           "acm:List*",
#         ],
#         Resource = "*",
#       }
#     ]
#   })
# }