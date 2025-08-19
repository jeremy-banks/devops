resource "aws_organizations_account" "sdlc_prd" {
  name  = "${var.account_name_slug.sdlc}-prd"
  email = "${var.org_owner_email_prefix}-${var.account_name_slug.sdlc}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_prd.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "sdlc_stg" {
  name  = "${var.account_name_slug.sdlc}-stg"
  email = "${var.org_owner_email_prefix}-${var.account_name_slug.sdlc}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_stg.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "sdlc_tst" {
  name  = "${var.account_name_slug.sdlc}-tst"
  email = "${var.org_owner_email_prefix}-${var.account_name_slug.sdlc}-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_tst.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "sdlc_dev" {
  name  = "${var.account_name_slug.sdlc}-dev"
  email = "${var.org_owner_email_prefix}-${var.account_name_slug.sdlc}-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.sdlc_dev.id
  role_name                  = var.account_role_name
}