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

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = [
      "kms:DescribeKey",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
      "kms:Decrypt",
      "kms:DeriveSharedSecret",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:GenerateMac",
      "kms:GetPublicKey",
      "kms:ReEncrypt*",
      "kms:ReEncrypt*",
      "kms:Sign",
      "kms:Verify",
      "kms:VerifyMac",
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/*",
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/*",
      ]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
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
      values   = [true]
    }
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/*",
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/*",
      ]
    }
  }
}

module "kms_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"
  providers = { aws = aws.sdlc_prd }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_stub}-${var.region.primary_short}"]

  policy = data.aws_iam_policy_document.kms.json
}

module "kms_failover" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"
  providers = { aws = aws.sdlc_prd_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_stub}-${var.region.failover_short}"]

  policy = data.aws_iam_policy_document.kms.json
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