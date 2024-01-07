module "kms_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"
  providers = { aws = aws.project_demo_nonprod }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_env_stub}-primary"]

  policy = data.aws_iam_policy_document.kms.json
}

module "kms_failover" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"
  providers = { aws = aws.project_demo_nonprod_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_env_stub}-replica"]

  policy = data.aws_iam_policy_document.kms.json
}

data "aws_caller_identity" "project_demo_nonprod" { provider = aws.project_demo_nonprod }

data "aws_iam_policy_document" "kms"  {
  statement {
    sid    = "Default"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.project_demo_nonprod.account_id}:root"]
    }

    actions   = ["kms:*"]

    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the key"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.project_demo_nonprod.account_id}:root"]
    }

    actions   = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.project_demo_nonprod.account_id}"]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.project_demo_nonprod.account_id}:root"]
    }

    actions   = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = ["*"]
  
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.project_demo_nonprod.account_id}"]
    }
  }
}
