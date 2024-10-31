module "dynamodb_primary" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "4.2.0"
  providers = { aws = aws.org }

  name     = "${local.resource_name_stub_primary}-${var.this_slug}"
  hash_key       = "LockID"
  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
}

module "dynamodb_failover" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "4.2.0"
  providers = { aws = aws.org_failover }

  name     = "${local.resource_name_stub_failover}-${var.this_slug}"
  hash_key       = "LockID"
  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
}