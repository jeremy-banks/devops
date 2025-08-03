resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "infrastructure"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

# resource "aws_organizations_organizational_unit" "infrastructure_stg" {
#   name      = "stg"
#   parent_id = aws_organizations_organizational_unit.infrastructure.id
# }