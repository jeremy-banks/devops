resource "aws_organizations_organizational_unit" "shared_services" {
  provider = aws.management

  name      = var.account_name.shared_services
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "shared_services_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}

resource "aws_organizations_organizational_unit" "shared_services_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}