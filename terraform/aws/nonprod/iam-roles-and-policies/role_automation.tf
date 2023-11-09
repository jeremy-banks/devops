module "role_automation" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.30.1"

  create_role = true

  role_name = "${local.resource_name_stub}-automation"

  trusted_role_arns = [
    "arn:aws:iam::${var.identity_account_number}:root"
  ]

  role_requires_mfa = false

  attach_admin_policy = true

  role_permissions_boundary_arn = aws_iam_policy.permission_boundary_automation.arn
}