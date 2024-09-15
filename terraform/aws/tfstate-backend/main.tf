#kms key
data "aws_caller_identity" "org" { provider = aws.org }

data "aws_iam_policy_document" "kms"  {
  statement {
    sid    = "Default"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.org.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # statement {
  #   sid    = "AllowUseOfKey"
  #   effect = "Allow"
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["arn:aws:iam::${data.aws_caller_identity.org.account_id}:role/automation"]
  #   }
  #   actions   = [
  #     "kms:Decrypt",
  #     "kms:DescribeKey",
  #     "kms:Encrypt",
  #     "kms:GenerateDataKey*",
  #     "kms:ReEncrypt*",
  #   ]
  #   resources = ["*"]
  # }
}

module "kms_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"
  providers = { aws = aws.org }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_stub_env}-tfstate"]

  policy = data.aws_iam_policy_document.kms.json
}

#s3 bucket
module "s3_primary" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"
  providers = { aws = aws.org }

  bucket = "${local.resource_name_stub_env}-tfstate"

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms_primary.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}