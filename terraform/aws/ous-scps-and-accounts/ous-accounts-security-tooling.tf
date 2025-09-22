resource "aws_organizations_organizational_unit" "security_tooling" {
  provider = aws.management

  name      = var.account_name.security_tooling
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_organizational_unit" "security_tooling_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_account" "security_tooling_prd" {
  provider = aws.management

  name  = "${var.account_name.security_tooling}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.security_tooling}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_tooling_prd.id
  role_name                  = var.account_role_name
}

output "security_tooling_prd" { value = aws_organizations_account.security_tooling_prd.id }

resource "aws_organizations_organizational_unit" "security_tooling_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_account" "security_tooling_stg" {
  provider = aws.management

  name  = "${var.account_name.security_tooling}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.security_tooling}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_tooling_stg.id
  role_name                  = var.account_role_name
}

output "security_tooling_stg" { value = aws_organizations_account.security_tooling_stg.id }