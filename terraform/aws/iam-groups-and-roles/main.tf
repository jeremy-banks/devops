data "aws_organizations_organization" "current" {}

# admin
module "iam_group_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.32.0"

  name = "admin"

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
    resources = ["arn:aws:iam::*:role/admin"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.current.id]
    }
  }
}

# #devops
# module "iam_group_devops" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.32.0"

#   name = "devops"

#   attach_iam_self_management_policy = true
#   enable_mfa_enforcement = true

#   # custom_group_policy_arns = []

#   custom_group_policies = [
#     {
#       name   = "AllowAssumeRoleDevOpsInOrg"
#       policy = data.aws_iam_policy_document.iam_group_devops_assume_role_policy.json
#     },
#   ]
# }

# data "aws_iam_policy_document" "iam_group_devops_assume_role_policy" {
#   statement {
#     sid = "AllowAssumeRoleDevOpsInOrg"
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]
#     resources = ["arn:aws:iam::*:role/devops"]
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalOrgID"
#       values = [data.aws_organizations_organization.current.id]
#     }
#   }
# }

# #dev
# module "iam_group_dev" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.32.0"

#   name = "dev"

#   attach_iam_self_management_policy = true
#   enable_mfa_enforcement = true

#   # custom_group_policy_arns = []

#   custom_group_policies = [
#     {
#       name   = "AllowAssumeRoleDevInOrg"
#       policy = data.aws_iam_policy_document.iam_group_dev_assume_role_policy.json
#     },
#   ]
# }

# data "aws_iam_policy_document" "iam_group_dev_assume_role_policy" {
#   statement {
#     sid = "AllowAssumeRoleDevInOrg"
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]
#     resources = ["arn:aws:iam::*:role/dev"]
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalOrgID"
#       values = [data.aws_organizations_organization.current.id]
#     }
#   }
# }

# #ops
# module "iam_group_ops" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.32.0"

#   name = "ops"

#   attach_iam_self_management_policy = true
#   enable_mfa_enforcement = true

#   # custom_group_policy_arns = []

#   custom_group_policies = [
#     {
#       name   = "AllowAssumeRoleOpsInOrg"
#       policy = data.aws_iam_policy_document.iam_group_ops_assume_role_policy.json
#     },
#   ]
# }

# data "aws_iam_policy_document" "iam_group_ops_assume_role_policy" {
#   statement {
#     sid = "AllowAssumeRoleOpsInOrg"
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]
#     resources = ["arn:aws:iam::*:role/ops"]
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalOrgID"
#       values = [data.aws_organizations_organization.current.id]
#     }
#   }
# }

# #qa
# module "iam_group_qa" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.32.0"

#   name = "qa"

#   attach_iam_self_management_policy = true
#   enable_mfa_enforcement = true

#   # custom_group_policy_arns = []

#   custom_group_policies = [
#     {
#       name   = "AllowAssumeRoleQAInOrg"
#       policy = data.aws_iam_policy_document.iam_group_qa_assume_role_policy.json
#     },
#   ]
# }

# data "aws_iam_policy_document" "iam_group_qa_assume_role_policy" {
#   statement {
#     sid = "AllowAssumeRoleQAInOrg"
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]
#     resources = ["arn:aws:iam::*:role/qa"]
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalOrgID"
#       values = [data.aws_organizations_organization.current.id]
#     }
#   }
# }

# #billing
# module "iam_group_billing" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.32.0"

#   name = "billing"

#   attach_iam_self_management_policy = true
#   enable_mfa_enforcement = true

#   custom_group_policy_arns = [
#     "arn:aws:iam::aws:policy/job-function/Billing",
#   ]

#   custom_group_policies = [
#     {
#       name   = "AllowAssumeRoleBillingInOrg"
#       policy = data.aws_iam_policy_document.iam_group_billing_assume_role_policy.json
#     },
#   ]
# }

# data "aws_iam_policy_document" "iam_group_billing_assume_role_policy" {
#   statement {
#     sid = "AllowAssumeRoleBillingInOrg"
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]
#     resources = ["arn:aws:iam::*:role/billing"]
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalOrgID"
#       values = [data.aws_organizations_organization.current.id]
#     }
#   }
# }




# module "iam_assumable_roles" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
#   version = "5.32.0"

#   trusted_role_arns = [
#      "arn:aws:iam::${aws_organizations_account.shared_services.id}:root",
#   ]

#   create_admin_role = true
#   create_poweruser_role = true
#   create_readonly_role  = true

#   max_session_duration = 43200
# }

# module "iam_assumable_role_devops" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.32.0"

#   create_role = true

#   role_name = "devops"
#   attach_admin_policy = true

#   trusted_role_arns = [
#     "arn:aws:iam::${aws_organizations_account.org.id}:root",
#   ]

#   max_session_duration = 43200
#   role_requires_mfa = false
# }

# module "iam_assumable_role_automation" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.32.0"

#   create_role = true

#   role_name = "automation"
#   attach_admin_policy = true

#   trusted_role_arns = [
#      "arn:aws:iam::${aws_organizations_account.org.id}:root",
#   ]

#   max_session_duration = 43200
#   role_requires_mfa = false
# }

# module "iam_assumable_role_billing" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
#   version = "5.32.0"

#   create_role = true
  
#   role_name = "billing"
#   attach_readonly_policy = true

#   trusted_role_arns = [
#      "arn:aws:iam::${aws_organizations_account.org.id}:root",
#   ]

#   max_session_duration = 43200
#   role_requires_mfa = false
# }

# resource "aws_organizations_account" "r53" {
#   name  = "${local.resource_name_stub}-r53"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-r53@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   role_name                   = var.assumable_role_name.superadmin
# }

# resource "aws_organizations_account" "nonprod" {
#   name  = "${local.resource_name_stub}-nonprod"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-nonprod@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   role_name                   = var.assumable_role_name.superadmin
# }

# resource "aws_organizations_account" "prod" {
#   name  = "${local.resource_name_stub}-prod"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-prod@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   role_name                   = var.assumable_role_name.superadmin
# }