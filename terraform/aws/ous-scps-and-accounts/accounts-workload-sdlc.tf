output "sdlc_prd" { value = aws_organizations_account.sdlc_prd.id }

resource "aws_organizations_account" "sdlc_prd" {
  provider = aws.management

  name  = "${var.account_name.sdlc}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.sdlc}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_prd.id
  role_name                  = var.account_role_name
}

output "sdlc_stg" { value = aws_organizations_account.sdlc_stg.id }

resource "aws_organizations_account" "sdlc_stg" {
  provider = aws.management

  name  = "${var.account_name.sdlc}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.sdlc}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_stg.id
  role_name                  = var.account_role_name
}

output "sdlc_tst" { value = aws_organizations_account.sdlc_tst.id }

resource "aws_organizations_account" "sdlc_tst" {
  provider = aws.management

  name  = "${var.account_name.sdlc}-tst"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.sdlc}-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_tst.id
  role_name                  = var.account_role_name
}

output "sdlc_dev" { value = aws_organizations_account.sdlc_dev.id }

resource "aws_organizations_account" "sdlc_dev" {
  provider = aws.management

  name  = "${var.account_name.sdlc}-dev"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.sdlc}-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_dev.id
  role_name                  = var.account_role_name
}