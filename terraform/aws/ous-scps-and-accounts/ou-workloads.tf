resource "aws_organizations_organizational_unit" "workloads" {
  name      = "workloads"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_tst" {
  name      = "tst"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_dev" {
  name      = "dev"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

