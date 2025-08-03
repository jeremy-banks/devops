resource "aws_organizations_organizational_unit" "security" {
  name      = "security"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "security_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.security.id
}

# resource "aws_organizations_organizational_unit" "security_stg" {
#   name      = "stg"
#   parent_id = aws_organizations_organizational_unit.security.id
# }

# resource "aws_organizations_organizational_unit" "security_tst" {
#   name      = "tst"
#   parent_id = aws_organizations_organizational_unit.security.id
# }

# resource "aws_organizations_organizational_unit" "security_dev" {
#   name      = "dev"
#   parent_id = aws_organizations_organizational_unit.security.id
# }
