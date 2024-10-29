data "aws_caller_identity" "current" {}

locals {
  unique_id = substr(sha256("foo${data.aws_caller_identity.current.account_id}"), 0, 8)
}