data "aws_caller_identity" "this" { provider = aws.management }

data "aws_organizations_organization" "this" { provider = aws.management }

locals {
  confused_deputy_protection_allowed_accounts = [
    "0123456789012",
    "0123456789013",
  ]
}