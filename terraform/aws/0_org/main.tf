resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"
}

resource "aws_organizations_account" "iam" {
  name  = "${local.resource_name_stub}-iam"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-iam@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  role_name                   = "admin"
}

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "5.32.0"

  trusted_role_arns = [
     "arn:aws:iam::${aws_organizations_account.iam.id}:root",
  ]

  create_admin_role = true
  create_poweruser_role = false
  create_readonly_role  = false

  max_session_duration = 43200
}

module "iam_assumable_role_devops" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  create_role = true

  role_name = "devops"
  attach_admin_policy = true

  trusted_role_arns = [
     "arn:aws:iam::${aws_organizations_account.iam.id}:root",
  ]

  max_session_duration = 43200
  role_requires_mfa = false
}

module "iam_assumable_role_automation" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  create_role = true

  role_name = "automation"
  attach_admin_policy = true

  trusted_role_arns = [
     "arn:aws:iam::${aws_organizations_account.iam.id}:root",
  ]

  max_session_duration = 43200
  role_requires_mfa = false
}

module "iam_assumable_role_billing" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.32.0"

  create_role = true
  
  role_name = "billing"
  attach_readonly_policy = true

  trusted_role_arns = [
     "arn:aws:iam::${aws_organizations_account.iam.id}:root",
  ]

  max_session_duration = 43200
  role_requires_mfa = false
}

resource "aws_organizations_account" "r53" {
  name  = "${local.resource_name_stub}-r53"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-r53@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  role_name                   = "admin"
}

resource "aws_organizations_account" "nonprod" {
  name  = "${local.resource_name_stub}-nonprod"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-nonprod@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  role_name                   = "admin"
}

resource "aws_organizations_account" "prod" {
  name  = "${local.resource_name_stub}-prod"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-prod@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  role_name                   = "admin"
}