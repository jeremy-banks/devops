module "role_dev" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.30.1"

  create_role = true

  role_name = "${local.resource_name_stub}-dev"

  trusted_role_arns = [
    "arn:aws:iam::${var.identity_account_number}:root"
  ]

  role_requires_mfa = true

  attach_admin_policy = false

  role_permissions_boundary_arn = aws_iam_policy.permission_boundary.arn
  # role_policy_arns = [
  #   "arn:aws:iam::aws:policy/ReadOnlyAccess"
  # ]
  # number_of_role_policy_arns = 1

  # role_permissions_boundary_arn = later
}