resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "infrastructure"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}