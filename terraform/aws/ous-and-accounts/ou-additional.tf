resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "sandbox"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "exceptions" {
  name      = "exceptions"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "transitional" {
  name      = "transitional"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "policy_staging" {
  name      = "policy-staging"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "suspended" {
  name      = "suspended"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "individual_business_users" {
  name      = "individual-business-users"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "deployments" {
  name      = "deployments"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "business_continuity" {
  name      = "business-continuity"
  parent_id = data.aws_organizations_organization.this.roots[0].id
}