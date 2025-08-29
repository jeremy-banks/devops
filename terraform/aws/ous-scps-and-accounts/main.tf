data "aws_caller_identity" "this" { provider = aws.management }

data "aws_organizations_organization" "this" { provider = aws.management }