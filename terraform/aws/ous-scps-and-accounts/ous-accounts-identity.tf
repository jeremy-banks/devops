resource "aws_organizations_organizational_unit" "identity" {
  provider = aws.management

  name      = var.account_name.identity
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "identity_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_account" "identity_prd" {
  provider = aws.management

  name  = "${var.account_name.identity}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.identity}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.identity_prd.id
  role_name                  = var.account_role_name
}

output "identity_prd" { value = aws_organizations_account.identity_prd.id }

resource "aws_organizations_organizational_unit" "identity_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_account" "identity_stg" {
  provider = aws.management

  name  = "${var.account_name.identity}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.identity}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.identity_stg.id
  role_name                  = var.account_role_name
}

output "identity_stg" { value = aws_organizations_account.identity_stg.id }