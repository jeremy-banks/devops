resource "aws_organizations_account" "log_archive_prd" {
  name  = "${var.account_name_slug.log_archive}-prd"
  email = "${var.org_owner_email_prefix}-${var.account_name_slug.log_archive}-prd@${var.org_owner_email_domain_tld}"
  # email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.log_archive}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.log_archive_prd.id
  role_name                  = var.account_role_name
}