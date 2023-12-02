resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"
}

# resource "aws_servicequotas_service_quota" "ACCOUNT_NUMBER_LIMIT_EXCEEDED" {
#   quota_code   = "L-29A0C5DF"
#   service_code = "organizations"
#   value        = var.ACCOUNT_NUMBER_LIMIT_EXCEEDED
# }

# resource "aws_servicequotas_service_quota" "CLOSE_ACCOUNT_QUOTA_EXCEEDED" {
#   provider = aws.org-failover
#   quota_code   = "L-55309E5F"
#   service_code = "organizations"
#   value        = 200
# }

resource "aws_organizations_organizational_unit" "security" {
  name      = "security"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "infrastructure"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "workloads"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "security_tooling" {
  name  = "${local.resource_name_stub}-security-tooling"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-security-tooling@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.security.id
  role_name                   = var.assumable_role_name.superadmin
}

# resource "aws_organizations_account" "log_archive" {
#   name  = "${local.resource_name_stub}-log-archive"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-log-archive@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.security.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# resource "aws_organizations_account" "network" {
#   name  = "${local.resource_name_stub}-network"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-network@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.infrastructure.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# resource "aws_organizations_account" "shared_services" {
#   name  = "${local.resource_name_stub}-shared-services"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-shared-services@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.infrastructure.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# resource "aws_organizations_account" "project1_nonprod" {
#   name  = "${local.resource_name_stub}-project1-nonprod"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-project1-nonprod@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# resource "aws_organizations_account" "project1_prod" {
#   name  = "${local.resource_name_stub}-project1-prod"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-project1-prod@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
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