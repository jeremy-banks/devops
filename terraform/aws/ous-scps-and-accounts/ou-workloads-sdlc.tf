resource "aws_organizations_organizational_unit" "sdlc" {
  name      = var.account_name_slug.sdlc
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "sdlc_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}

resource "aws_organizations_organizational_unit" "sdlc_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}

resource "aws_organizations_organizational_unit" "sdlc_tst" {
  name      = "tst"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}

resource "aws_organizations_organizational_unit" "sdlc_dev" {
  name      = "dev"
  parent_id = aws_organizations_organizational_unit.sdlc.id
}