# module "role_ops" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.30.1"

#   create_role = true

#   role_name = "${local.resource_name_stub}-ops"

#   trusted_role_arns = [
#     "arn:aws:iam::${var.identity_account_number}:root"
#   ]

#   role_requires_mfa = true

#   attach_admin_policy = false

#   role_permissions_boundary_arn = aws_iam_policy.permission_boundary.arn

#   custom_role_policy_arns = [
#     aws_iam_policy.allow_readonly.arn,
#     aws_iam_policy.role_ops.arn
#   ]
#   number_of_custom_role_policy_arns = 2
# }

# resource "aws_iam_policy" "role_ops" {
#   name        = "${local.resource_name_stub}-role-ops"

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