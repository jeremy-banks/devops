resource "aws_organizations_account" "identity" {
  name  = "identity"
  email = "${var.org_owner_email_prefix}-identity@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.infrastructure.id
  role_name                   = var.assumable_role_name.superadmin
}

resource "aws_organizations_account" "network" {
  name  = "network"
  email = "${var.org_owner_email_prefix}-network@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.infrastructure.id
  role_name                   = var.assumable_role_name.superadmin
}