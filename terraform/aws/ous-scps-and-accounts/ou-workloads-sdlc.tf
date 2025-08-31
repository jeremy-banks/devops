resource "aws_organizations_organizational_unit" "sdlc" {
  provider = aws.management

  name      = var.account_name.sdlc
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "sdlc_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}

resource "aws_organizations_organizational_unit" "sdlc_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}

resource "aws_organizations_organizational_unit" "sdlc_tst" {
  provider = aws.management

  name      = "tst"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}

resource "aws_organizations_organizational_unit" "sdlc_dev" {
  provider = aws.management

  name      = "dev"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}