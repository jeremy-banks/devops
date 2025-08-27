data "aws_iam_policy_document" "kms" {
  # https://docs.aws.amazon.com/kms/latest/prdeloperguide/key-policy-default.html
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.id}:root"]
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
    actions = [
      "kms:Decrypt",
      "kms:DeriveSharedSecret",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:GenerateMac",
      "kms:GetPublicKey",
      "kms:ReEncrypt*",
      "kms:Sign",
      "kms:Verify",
      "kms:VerifyMac",
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.this.id}:instance-profile/*",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:role/*",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:role/aws-service-role/*",
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
    actions = [
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
      values = [
        "arn:aws:iam::${data.aws_caller_identity.this.id}:instance-profile/*",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:role/*",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:role/aws-service-role/*",
      ]
    }
  }
}

module "kms_primary" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "4.0.0"
  providers = { aws = aws.this }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_primary}"]

  policy = data.aws_iam_policy_document.kms.json
}

module "kms_failover" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "4.0.0"
  providers = { aws = aws.this_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_failover}"]

  policy = data.aws_iam_policy_document.kms.json
}

resource "aws_ebs_encryption_by_default" "kms_primary" {
  provider = aws.this

  enabled = true
}

resource "aws_ebs_default_kms_key" "kms_primary" {
  provider = aws.this

  key_arn = module.kms_primary.key_arn
}

resource "aws_ebs_encryption_by_default" "kms_failover" {
  provider = aws.this_failover

  enabled = true
}

resource "aws_ebs_default_kms_key" "kms_failover" {
  provider = aws.this_failover

  key_arn = module.kms_failover.key_arn
}