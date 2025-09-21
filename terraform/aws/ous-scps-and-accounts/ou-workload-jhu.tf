resource "aws_organizations_organizational_unit" "workload_jhu" {
  provider = aws.management

  name      = var.account_name.workload_jhu
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workload_jhu_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.workload_jhu.id
}

resource "aws_organizations_organizational_unit" "workload_jhu_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.workload_jhu.id
}

resource "aws_organizations_organizational_unit" "workload_jhu_tst" {
  provider = aws.management

  name      = "tst"
  parent_id = aws_organizations_organizational_unit.workload_jhu.id
}

resource "aws_organizations_organizational_unit" "workload_jhu_dev" {
  provider = aws.management

  name      = "dev"
  parent_id = aws_organizations_organizational_unit.workload_jhu.id
}