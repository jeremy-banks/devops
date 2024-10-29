resource "aws_organizations_organizational_unit" "sdlc" {
  name      = "sdlc"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "customer_a" {
  name      = "customer_a"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "customer_b" {
  name      = "customer_b"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "customer_c" {
  name      = "customer_c"
  parent_id = aws_organizations_organizational_unit.workloads.id
}