resource "aws_organizations_organizational_unit" "security_tooling" {
  provider = aws.management

  name      = var.account_name.security_tooling
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_organizational_unit" "security_tooling_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_organizational_unit" "security_tooling_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_organizational_unit" "security_tooling_tst" {
  provider = aws.management

  name      = "tst"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_organizational_unit" "security_tooling_dev" {
  provider = aws.management

  name      = "dev"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}