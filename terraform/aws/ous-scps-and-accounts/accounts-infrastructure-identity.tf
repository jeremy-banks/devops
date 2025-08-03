resource "aws_organizations_account" "identity_prd" {
  name  = "identity-prd"
  email = local.account_owner_email.identity_prd

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.infrastructure_prd.id
  role_name                  = var.account_role_name
}