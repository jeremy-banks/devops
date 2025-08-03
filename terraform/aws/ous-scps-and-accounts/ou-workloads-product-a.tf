resource "aws_organizations_organizational_unit" "workloads_product_a" {
  name      = "product-a"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_product_a_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.workloads_product_a.id
}

resource "aws_organizations_organizational_unit" "workloads_product_a_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.workloads_product_a.id
}

# resource "aws_organizations_organizational_unit" "workloads_product_a_tst" {
#   name      = "tst"
#   parent_id = aws_organizations_organizational_unit.workloads_product_a.id
# }

# resource "aws_organizations_organizational_unit" "workloads_product_a_dev" {
#   name      = "dev"
#   parent_id = aws_organizations_organizational_unit.workloads_product_a.id
# }