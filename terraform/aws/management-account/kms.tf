data "aws_iam_policy_document" "kms" {
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
    actions = [
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
      values = [
        "arn:aws:iam::*:role/${var.assumable_role_name.automation}",
        "arn:aws:iam::*:role/${var.assumable_role_name.superadmin}",
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [
        "${aws_organizations_organization.this.id}",
      ]
    }
  }
}

module "kms_primary" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "3.1.1"
  providers = { aws = aws.org }

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_stub_primary}-${var.this_slug}"]

  policy = data.aws_iam_policy_document.kms.json
}

module "kms_failover" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "3.1.1"
  providers = { aws = aws.org_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_stub_failover}-${var.this_slug}"]

  policy = data.aws_iam_policy_document.kms.json
}