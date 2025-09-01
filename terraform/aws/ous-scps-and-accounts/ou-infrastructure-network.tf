resource "aws_organizations_organizational_unit" "network" {
  provider = aws.management

  name      = var.account_name.network
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "network_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.network.id
}

resource "aws_organizations_organizational_unit" "network_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.network.id
}