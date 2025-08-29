resource "aws_organizations_organizational_unit" "sandbox" {
  provider = aws.management

  name      = "sandbox"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "exceptions" {
  provider = aws.management

  name      = "exceptions"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "transitional" {
  provider = aws.management

  name      = "transitional"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "policy_staging" {
  provider = aws.management

  name      = "policy-staging"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "suspended" {
  provider = aws.management

  name      = "suspended"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "individual_business_users" {
  provider = aws.management

  name      = "individual-business-users"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "deployments" {
  provider = aws.management

  name      = "deployments"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "business_continuity" {
  provider = aws.management

  name      = "business-continuity"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}