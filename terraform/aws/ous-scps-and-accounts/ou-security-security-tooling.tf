resource "aws_organizations_organizational_unit" "security_tooling" {
  name      = var.account_name_slug.security_tooling
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_organizational_unit" "security_tooling_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_organizational_unit" "security_tooling_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_organizational_unit" "security_tooling_tst" {
  name      = "tst"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}

resource "aws_organizations_organizational_unit" "security_tooling_dev" {
  name      = "dev"
  parent_id = aws_organizations_organizational_unit.security_tooling.id
}