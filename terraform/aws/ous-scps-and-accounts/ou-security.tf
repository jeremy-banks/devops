resource "aws_organizations_organizational_unit" "security" {
  provider = aws.management

  name      = "security"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}