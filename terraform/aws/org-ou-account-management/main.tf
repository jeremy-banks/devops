resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"
}

resource "aws_ram_sharing_with_organization" "enable" {}

data "aws_caller_identity" "current" {}

#https://github.com/hashicorp/terraform-provider-aws/issues/14731
# resource "aws_servicequotas_service_quota" "ACCOUNT_NUMBER_LIMIT_EXCEEDED" {
#   quota_code   = "L-29A0C5DF"
#   service_code = "organizations"
#   value        = var.ACCOUNT_NUMBER_LIMIT_EXCEEDED
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

resource "aws_organizations_account" "log_archive" {
  name  = "${local.resource_name_stub}-log-archive"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-log-archive@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.security.id
  role_name                   = var.assumable_role_name.superadmin
}

resource "aws_organizations_account" "network" {
  name  = "${local.resource_name_stub}-network"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-network@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.infrastructure.id
  role_name                   = var.assumable_role_name.superadmin
}

resource "aws_organizations_account" "shared_services" {
  name  = "${local.resource_name_stub}-shared-services"
  email = "${var.company_email_prefix}+${local.resource_name_stub}-shared-services@${var.company_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.infrastructure.id
  role_name                   = var.assumable_role_name.superadmin
}
