# users
data "aws_iam_user" "superadmin" {
  user_name = var.assumable_role_name.superadmin
}

module "iam_user_automation" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.32.0"

  providers = { aws = aws.shared_services }

  name = var.assumable_role_name.automation

  create_iam_user_login_profile = false
  create_iam_access_key         = true
}

# groups
data "aws_organizations_organization" "current" {}

module "iam_group_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  providers = { aws = aws.shared_services }

  name = var.assumable_roles_name.admin

  attach_iam_self_management_policy = true
  enable_mfa_enforcement = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]

  custom_group_policies = [
    {
      name   = "AllowAssumeRoleAdminInOrg"
      policy = data.aws_iam_policy_document.iam_group_admin_assume_role_policy.json
    },
  ]
}

data "aws_iam_policy_document" "iam_group_admin_assume_role_policy" {
  statement {
    sid = "AllowAssumeRoleAdminInOrg"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${var.assumable_roles_name.admin}"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.current.id]
    }
  }
}

module "iam_group_devops" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  providers = { aws = aws.shared_services }

  name = "devops"

  attach_iam_self_management_policy = true
  enable_mfa_enforcement = true

  # custom_group_policy_arns = []

  custom_group_policies = [
    {
      name   = "AllowAssumeRoleDevOpsInOrg"
      policy = data.aws_iam_policy_document.iam_group_devops_assume_role_policy.json
    },
  ]
}

data "aws_iam_policy_document" "iam_group_devops_assume_role_policy" {
  statement {
    sid = "AllowAssumeRoleDevOpsInOrg"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/devops"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.current.id]
    }
  }
}

module "iam_group_dev" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  providers = { aws = aws.shared_services }
  
  name = "dev"

  attach_iam_self_management_policy = true
  enable_mfa_enforcement = true

  # custom_group_policy_arns = []

  custom_group_policies = [
    {
      name   = "AllowAssumeRoleDevInOrg"
      policy = data.aws_iam_policy_document.iam_group_dev_assume_role_policy.json
    },
  ]
}

data "aws_iam_policy_document" "iam_group_dev_assume_role_policy" {
  statement {
    sid = "AllowAssumeRoleDevInOrg"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/dev"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.current.id]
    }
  }
}

module "iam_group_ops" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  providers = { aws = aws.shared_services }
  
  name = "ops"

  attach_iam_self_management_policy = true
  enable_mfa_enforcement = true

  # custom_group_policy_arns = []

  custom_group_policies = [
    {
      name   = "AllowAssumeRoleOpsInOrg"
      policy = data.aws_iam_policy_document.iam_group_ops_assume_role_policy.json
    },
  ]
}

data "aws_iam_policy_document" "iam_group_ops_assume_role_policy" {
  statement {
    sid = "AllowAssumeRoleOpsInOrg"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/ops"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.current.id]
    }
  }
}

module "iam_group_qa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  providers = { aws = aws.shared_services }
  
  name = "qa"

  attach_iam_self_management_policy = true
  enable_mfa_enforcement = true

  # custom_group_policy_arns = []

  custom_group_policies = [
    {
      name   = "AllowAssumeRoleQAInOrg"
      policy = data.aws_iam_policy_document.iam_group_qa_assume_role_policy.json
    },
  ]
}

data "aws_iam_policy_document" "iam_group_qa_assume_role_policy" {
  statement {
    sid = "AllowAssumeRoleQAInOrg"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/qa"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.current.id]
    }
  }
}

module "iam_group_billing" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  providers = { aws = aws.shared_services }
  
  name = "billing"

  attach_iam_self_management_policy = true
  enable_mfa_enforcement = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/Billing",
  ]

  custom_group_policies = [
    {
      name   = "AllowAssumeRoleBillingInOrg"
      policy = data.aws_iam_policy_document.iam_group_billing_assume_role_policy.json
    },
  ]
}

data "aws_iam_policy_document" "iam_group_billing_assume_role_policy" {
  statement {
    sid = "AllowAssumeRoleBillingInOrg"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/billing"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.current.id]
    }
  }
}

# roles
module "iam_assumable_roles_security_tooling" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.security_tooling }

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

module "iam_assumable_roles_log_archive" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.log_archive }

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

module "iam_assumable_roles_network" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.network }

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

module "iam_assumable_roles_shared_services" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  providers = { aws = aws.shared_services }

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

module "iam_assumable_role_automation_security_tooling" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  providers = { aws = aws.security_tooling }

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

module "iam_assumable_role_automation_log_archive" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  providers = { aws = aws.log_archive }

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

module "iam_assumable_role_automation_network" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  providers = { aws = aws.network }

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

module "iam_assumable_role_automation_shared_services" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  providers = { aws = aws.shared_services }

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


module "iam_assumable_role_billing_org" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  trusted_role_arns = [
     "arn:aws:iam::${var.account_id.shared_services}:root",
  ]

  create_role = true
  
  role_name = "billing"

  role_requires_mfa = false
  max_session_duration = 43200

  custom_role_policy_arns = ["arn:aws:iam::aws:policy/job-function/Billing"]
}