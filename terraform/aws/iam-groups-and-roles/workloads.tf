module "iam_assumable_roles_workload_dev" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"
  providers = { aws = aws.workload_dev }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.shared_services}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
  ]

  create_admin_role = true
  admin_role_name   = var.assumable_roles_name.admin

  create_poweruser_role = true
  poweruser_role_name   = var.assumable_roles_name.poweruser

  create_readonly_role        = true
  readonly_role_name          = var.assumable_roles_name.readonly
  readonly_role_requires_mfa  = false
  
  max_session_duration = 43200
}

module "iam_assumable_role_automation_workload_dev" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"
  providers = { aws = aws.workload_dev }

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.shared_services}:root",
     "arn:aws:iam::${var.account_id.org}:user/${var.assumable_role_name.superadmin}",
  ]

  create_role = true
  
  role_name = var.assumable_role_name.automation

  attach_admin_policy = true
  role_requires_mfa = false
  max_session_duration = 43200
}