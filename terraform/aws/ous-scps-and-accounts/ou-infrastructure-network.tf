resource "aws_organizations_organizational_unit" "network" {
  name      = var.account_name_slug.network
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "network_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.network.id
}

resource "aws_organizations_organizational_unit" "network_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.network.id
}

resource "aws_organizations_organizational_unit" "network_tst" {
  name      = "tst"
  parent_id = aws_organizations_organizational_unit.network.id
}

resource "aws_organizations_organizational_unit" "network_dev" {
  name      = "dev"
  parent_id = aws_organizations_organizational_unit.network.id
}