data "aws_caller_identity" "this" {}

data "aws_organizations_organization" "this" {}

locals { unique_id = substr(sha256("foo${data.aws_caller_identity.this.account_id}"), 0, 8) }