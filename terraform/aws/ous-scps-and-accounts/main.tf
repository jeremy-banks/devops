data "aws_caller_identity" "this" { provider = aws.management }

data "aws_organizations_organization" "this" { provider = aws.management }

locals {
  third_party_account_ids = [
    "0123456789012",
    "0123456789013",
  ]
}