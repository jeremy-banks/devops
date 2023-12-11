module "iam_assumable_roles_network" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.network }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.shared_services}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
  ]

  create_admin_role = true

  create_poweruser_role = true

  create_readonly_role  = true
  readonly_role_requires_mfa = false
}

module "iam_assumable_roles_shared_services" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.shared_services }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.shared_services}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
  ]

  create_admin_role = true

  create_poweruser_role = true

  create_readonly_role  = true
  readonly_role_requires_mfa = false
}

module "iam_assumable_roles_log_archive" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.log_archive }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.shared_services}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
  ]

  create_admin_role = true

  create_poweruser_role = true

  create_readonly_role  = true
  readonly_role_requires_mfa = false
}

module "iam_assumable_roles_security_tooling" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.security_tooling }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.shared_services}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.automation}",
  ]

  create_admin_role = true

  create_poweruser_role = true

  create_readonly_role  = true
  readonly_role_requires_mfa = false
}