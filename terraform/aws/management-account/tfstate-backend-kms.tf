data "aws_iam_policy_document" "kms_tfstate_backend" {
  provider = aws.management

  # https://docs.aws.amazon.com/kms/latest/prdeloperguide/key-policy-default.html
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

module "kms_tfstate_backend_primary" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "~> 4.1.0"
  providers = { aws = aws.management }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name.primary}"]

  policy = data.aws_iam_policy_document.kms_tfstate_backend.json
}

module "kms_tfstate_backend_failover" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "~> 4.1.0"
  providers = { aws = aws.management_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_tfstate_backend_primary.key_arn

  aliases = ["${local.resource_name.failover}"]

  policy = data.aws_iam_policy_document.kms_tfstate_backend.json
}