resource "aws_organizations_organizational_unit" "shared_services" {
  name      = var.account_name_slug.shared_services
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "shared_services_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}

resource "aws_organizations_organizational_unit" "shared_services_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}

resource "aws_organizations_organizational_unit" "shared_services_tst" {
  name      = "tst"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}

resource "aws_organizations_organizational_unit" "shared_services_dev" {
  name      = "dev"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}