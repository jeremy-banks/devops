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