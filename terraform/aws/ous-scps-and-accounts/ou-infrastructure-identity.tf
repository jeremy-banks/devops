resource "aws_organizations_organizational_unit" "identity" {
  name      = var.account_name_slug.identity
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "identity_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_organizational_unit" "identity_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_organizational_unit" "identity_tst" {
  name      = "tst"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_organizational_unit" "identity_dev" {
  name      = "dev"
  parent_id = aws_organizations_organizational_unit.identity.id
}