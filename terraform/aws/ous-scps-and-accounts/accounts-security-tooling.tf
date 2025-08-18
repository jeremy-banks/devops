resource "aws_organizations_account" "security_tooling_prd" {
  name  = "${var.account_name_slug.security_tooling}-prd"
  email = "${var.org_owner_email_prefix}-${var.account_name_slug.security_tooling}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_tooling_prd.id
  role_name                  = var.account_role_name
}