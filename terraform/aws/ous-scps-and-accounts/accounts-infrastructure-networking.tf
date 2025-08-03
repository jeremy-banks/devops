resource "aws_organizations_account" "networking_prd" {
  name  = var.account_email_slug.networking_prd
  email = local.account_owner_email.networking_prd

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.infrastructure_prd.id
  role_name                  = var.account_role_name
}