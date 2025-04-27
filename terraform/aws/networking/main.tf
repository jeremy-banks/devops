data "aws_caller_identity" "this" { provider = aws.networking_prd }

data "aws_organizations_organization" "this" {}

data "aws_organizations_organizational_units" "top_level" { parent_id = data.aws_organizations_organization.this.roots[0].id }