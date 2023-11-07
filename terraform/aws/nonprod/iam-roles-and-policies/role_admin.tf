module "role_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.30.1"

  create_role = true

  role_name = "${local.resource_name_stub}-admin"

  trusted_role_arns = [
    "arn:aws:iam::${var.identity_account_number}:root"
  ]

  role_requires_mfa = true

  attach_admin_policy = true
}