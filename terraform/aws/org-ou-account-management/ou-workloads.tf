resource "aws_organizations_organizational_unit" "sdlc" {
  name      = "sdlc"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "customer_a" {
  name      = "customer_a"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_prod" {
  name      = "prod"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_nonprod" {
  name      = "nonprod"
  parent_id = aws_organizations_organizational_unit.workloads.id
}