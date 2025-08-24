data "aws_caller_identity" "this" { provider = aws.network_prd }

data "aws_organizations_organization" "this" {}

data "aws_organizations_organizational_units" "top_level" { parent_id = data.aws_organizations_organization.this.roots[0].id }

data "aws_organizations_organizational_unit" "infrastructure" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
  name      = "infrastructure"
}

data "aws_organizations_organizational_unit" "security" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
  name      = "security"
}

data "aws_organizations_organizational_unit" "workloads" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
  name      = "workloads"
}

