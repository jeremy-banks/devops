resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "infrastructure"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_account" "identity_prd" {
  name  = "identity-prd"
  email = local.account_owner_email.identity_prd

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.infrastructure_prd.id
  role_name                  = var.account_role_name
}

resource "aws_organizations_account" "networking_prd" {
  name  = "network-prd"
  email = local.account_owner_email.networking_prd

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.infrastructure_prd.id
  role_name                  = var.account_role_name
}

# resource "aws_organizations_organizational_unit" "infrastructure_stg" {
#   name      = "stg"
#   parent_id = aws_organizations_organizational_unit.infrastructure.id
# }

# resource "aws_organizations_organizational_unit" "infrastructure_tst" {
#   name      = "tst"
#   parent_id = aws_organizations_organizational_unit.infrastructure.id
# }

# resource "aws_organizations_organizational_unit" "infrastructure_dev" {
#   name      = "dev"
#   parent_id = aws_organizations_organizational_unit.infrastructure.id
# }
