module "iam_assumable_roles_workload_spoke_a_prd" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version   = "5.59.0"
  providers = { aws = aws.workload_spoke_a_prd }

  trusted_role_arns = ["arn:aws:iam::${data.aws_organizations_organization.this.master_account_id}:root"]

  create_admin_role       = true
  admin_role_name         = var.admin_role_name
  admin_role_requires_mfa = false

  create_poweruser_role = false

  create_readonly_role       = true
  readonly_role_requires_mfa = false

  max_session_duration = 43200
  mfa_age              = 86400
}