data "aws_caller_identity" "this" { provider = aws.org }

locals { unique_id = substr(sha256("foo${data.aws_caller_identity.this.account_id}"), 0, 8) }