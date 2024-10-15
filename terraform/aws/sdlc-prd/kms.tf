module "kms_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"
  providers = { aws = aws.sdlc_prd }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_prefix_env_region_primary_abbr}"]

  policy = data.aws_iam_policy_document.kms.json
}

module "kms_failover" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"
  providers = { aws = aws.sdlc_prd_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_prefix_env_region_failover_abbr}"]

  policy = data.aws_iam_policy_document.kms.json
}

data "aws_caller_identity" "this" { provider = aws.sdlc_prd }

data "aws_iam_policy_document" "kms"  {
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

  # https://docs.aws.amazon.com/autoscaling/ec2/userguide/key-policy-requirements-EBS-encryption.html
  # statement {
  #   sid    = "Allow service-linked role use of the customer managed key"

  #   effect = "Allow"

  #   principals {
  #     type        = "AWS"
  #     identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  #   }

  #   actions   = [
  #      "kms:Decrypt",
  #      "kms:DescribeKey",
  #      "kms:Encrypt",
  #      "kms:GenerateDataKey*",
  #      "kms:ReEncrypt*",
  #   ]

  #   resources = ["*"]
  # }

  # statement {
  #   sid    = "Allow attachment of persistent resources"

  #   effect = "Allow"

  #   principals {
  #     type        = "AWS"
  #     identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  #   }

  #   actions   = [
  #     "kms:CreateGrant",
  #   ]

  #   resources = ["*"]
  
  #   condition {
  #     test     = "Bool"
  #     variable = "kms:GrantIsForAWSResource"
  #     values   = ["true"]
  #   }
  # }
}

resource "aws_ebs_encryption_by_default" "kms_primary" {
  provider = aws.sdlc_prd

  enabled = true
}

resource "aws_ebs_default_kms_key" "kms_primary" {
  provider = aws.sdlc_prd

  key_arn = module.kms_primary.key_arn
}

resource "aws_ebs_encryption_by_default" "kms_failover" {
  provider = aws.sdlc_prd_failover

  enabled = true
}

resource "aws_ebs_default_kms_key" "kms_failover" {
  provider = aws.sdlc_prd_failover

  key_arn = module.kms_failover.key_arn
}