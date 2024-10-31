# module "iam_group_admin" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.45.0"
#   providers = { aws = aws.identity }

#   name = var.assumable_roles_name.admin

#   attach_iam_self_management_policy = true
#   enable_mfa_enforcement = true

#   custom_group_policy_arns = [
#     "arn:aws:iam::aws:policy/AdministratorAccess",
#   ]

#   custom_group_policies = [
#     {
#       name   = "AllowAssumeRoleAdminInOrg"
#       policy = data.aws_iam_policy_document.iam_group_admin_assume_role_policy.json
#     },
#   ]
# }

# data "aws_iam_policy_document" "iam_group_admin_assume_role_policy" {
#   statement {
#     sid = "AllowAssumeRoleAdminInOrg"
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]
#     resources = ["arn:aws:iam::*:role/${var.assumable_roles_name.admin}"]
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalOrgID"
#       values = [data.aws_organizations_organization.this.id]
#     }
#   }
# }

# module "iam_group_devops" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.45.0"
#   providers = { aws = aws.identity }

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
#       values = [data.aws_organizations_organization.this.id]
#     }
#   }
# }

# module "iam_group_dev" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.45.0"
#   providers = { aws = aws.identity }
  
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
#       values = [data.aws_organizations_organization.this.id]
#     }
#   }
# }

# module "iam_group_ops" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.45.0"
#   providers = { aws = aws.identity }
  
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
#       values = [data.aws_organizations_organization.this.id]
#     }
#   }
# }

# module "iam_group_qa" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.45.0"
#   providers = { aws = aws.identity }
  
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
#       values = [data.aws_organizations_organization.this.id]
#     }
#   }
# }

# module "iam_group_billing" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
#   version = "5.45.0"
#   providers = { aws = aws.identity }
  
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
#       values = [data.aws_organizations_organization.this.id]
#     }
#   }
# }