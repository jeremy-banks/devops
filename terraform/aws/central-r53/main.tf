data "aws_caller_identity" "root" {}

data "aws_caller_identity" "this" { provider = aws.network_prd }

data "aws_organizations_organization" "this" {}