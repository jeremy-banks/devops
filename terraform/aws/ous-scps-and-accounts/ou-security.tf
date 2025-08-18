resource "aws_organizations_organizational_unit" "security" {
  name      = "security"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}