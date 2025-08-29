resource "aws_organizations_account" "security_tooling_prd" {
  provider = aws.management

  name  = "${var.account_name_slug.security_tooling}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.security_tooling}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_tooling_prd.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "security_tooling_stg" {
  provider = aws.management

  name  = "${var.account_name_slug.security_tooling}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.security_tooling}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_tooling_stg.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "security_tooling_tst" {
  provider = aws.management

  name  = "${var.account_name_slug.security_tooling}-tst"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.security_tooling}-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_tooling_tst.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "security_tooling_dev" {
  provider = aws.management

  name  = "${var.account_name_slug.security_tooling}-dev"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.security_tooling}-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_tooling_dev.id
  role_name                  = var.account_role_name
}