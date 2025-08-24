data "aws_caller_identity" "this" { provider = aws.shared_services_prd }

data "aws_organizations_organization" "this" {}