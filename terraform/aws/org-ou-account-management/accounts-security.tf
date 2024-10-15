resource "aws_organizations_account" "log_archive" {
  name  = "log-archive"
  email = "${var.org_owner_email_prefix}-log-archive@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.security.id
  role_name                   = var.assumable_role_name.superadmin
}

resource "aws_organizations_account" "security_tooling" {
  name  = "security-tooling"
  email = "${var.org_owner_email_prefix}-security-tooling@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.security.id
  role_name                   = var.assumable_role_name.superadmin
}