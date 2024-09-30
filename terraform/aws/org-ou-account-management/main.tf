resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "config.amazonaws.com",
    "ds.amazonaws.com", #enterprise active directory
    "ram.amazonaws.com",
  ]

  feature_set = "ALL"
}

resource "aws_ram_sharing_with_organization" "enable" {
  depends_on = [
    aws_organizations_organization.org,
    aws_organizations_account.security_tooling,
    aws_organizations_account.log_archive,
    aws_organizations_account.network,
    aws_organizations_account.shared_services
  ]
}

data "aws_caller_identity" "current" {}

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
  name  = "${local.resource_name_prefix_abbr}-security-tooling"
  email = "${var.org_owner_email_prefix}-security-tooling@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.security.id
  role_name                   = var.assumable_role_name.superadmin
}

resource "aws_organizations_account" "log_archive" {
  name  = "${local.resource_name_prefix_abbr}-log-archive"
  email = "${var.org_owner_email_prefix}-log-archive@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.security.id
  role_name                   = var.assumable_role_name.superadmin
}

resource "aws_organizations_account" "network" {
  name  = "${local.resource_name_prefix_abbr}-network"
  email = "${var.org_owner_email_prefix}-network@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.infrastructure.id
  role_name                   = var.assumable_role_name.superadmin
}

resource "aws_organizations_account" "shared_services" {
  name  = "${local.resource_name_prefix_abbr}-shared-services"
  email = "${var.org_owner_email_prefix}-shared-services@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.infrastructure.id
  role_name                   = var.assumable_role_name.superadmin
}