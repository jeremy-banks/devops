resource "aws_organizations_organizational_unit" "infrastructure" {
  provider = aws.management

  name      = "infrastructure"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}