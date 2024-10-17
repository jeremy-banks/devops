data "aws_organizations_organization" "current" {
  provider = aws.org
}

data "aws_organizations_organizational_unit" "infrastructure" {
  provider = aws.org

  parent_id = data.aws_organizations_organization.current.roots[0].id
  name      = "infrastructure"
}

data "aws_organizations_organizational_unit" "security" {
  provider = aws.org

  parent_id = data.aws_organizations_organization.current.roots[0].id
  name      = "security"
}

data "aws_organizations_organizational_unit" "workloads" {
  provider = aws.org

  parent_id = data.aws_organizations_organization.current.roots[0].id
  name      = "workloads"
}