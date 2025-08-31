resource "aws_organizations_organizational_unit" "identity" {
  provider = aws.management

  name      = var.account_name.identity
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "identity_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_organizational_unit" "identity_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_organizational_unit" "identity_tst" {
  provider = aws.management

  name      = "tst"
  parent_id = aws_organizations_organizational_unit.identity.id
}

resource "aws_organizations_organizational_unit" "identity_dev" {
  provider = aws.management

  name      = "dev"
  parent_id = aws_organizations_organizational_unit.identity.id
}