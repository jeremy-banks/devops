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
    sid    = "Allow cryptographic operations by authorized roles in the org"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::*:role/${var.account_role_name}",
        "arn:aws:iam::*:role/${var.admin_role_name}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.this.id]
    }
  }
}

module "kms_primary" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "4.0.0"
  providers = { aws = aws.shared_services_prd }

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
  providers = { aws = aws.shared_services_prd_failover }

  count = var.create_failover_region_network ? 1 : 0

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_failover}"]

  policy = data.aws_iam_policy_document.kms.json
}

resource "aws_ebs_encryption_by_default" "kms_primary" {
  provider = aws.shared_services_prd

  enabled = true
}

resource "aws_ebs_default_kms_key" "kms_primary" {
  provider = aws.shared_services_prd

  key_arn = module.kms_primary.key_arn
}

resource "aws_ebs_encryption_by_default" "kms_failover" {
  provider = aws.shared_services_prd_failover

  enabled = true
}

resource "aws_ebs_default_kms_key" "kms_failover" {
  provider = aws.shared_services_prd_failover

  key_arn = module.kms_failover[0].key_arn
}