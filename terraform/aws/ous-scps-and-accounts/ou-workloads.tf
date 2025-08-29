resource "aws_organizations_organizational_unit" "workloads" {
  provider = aws.management

  name      = "workloads"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}