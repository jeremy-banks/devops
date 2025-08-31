resource "aws_organizations_organizational_unit" "workloads_product_a" {
  provider = aws.management

  name      = var.account_name.workload_product_a
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_product_a_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.workloads_product_a.id
}

resource "aws_organizations_organizational_unit" "workloads_product_a_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.workloads_product_a.id
}

resource "aws_organizations_organizational_unit" "workloads_product_a_tst" {
  provider = aws.management

  name      = "tst"
  parent_id = aws_organizations_organizational_unit.workloads_product_a.id
}

resource "aws_organizations_organizational_unit" "workloads_product_a_dev" {
  provider = aws.management

  name      = "dev"
  parent_id = aws_organizations_organizational_unit.workloads_product_a.id
}