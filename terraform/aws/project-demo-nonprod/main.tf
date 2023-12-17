# kms
module "kms_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_env_stub}-primary"]

  policy = data.aws_iam_policy_document.kms.json

  providers = { aws = aws.project_demo_nonprod }
}

module "kms_replica" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_primary.key_arn

  aliases = ["${local.resource_name_env_stub}-replica"]

  policy = data.aws_iam_policy_document.kms.json

  providers = { aws = aws.project_demo_nonprod_failover }
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

#acm
# module "acm_wildcard_cert" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.0.0"

#   domain_name = local.domain_name
#   subject_alternative_names = ["*.${local.domain_name}"]

#   create_route53_records  = false
#   validation_method       = "DNS"
#   validation_record_fqdns = module.acm_dns_records.validation_route53_record_fqdns
# }

# data "aws_route53_zone" "selected" {
#   name         = "${local.domain_name}."
#   private_zone = false

#   providers = { aws = aws.r53 }
# }

# module "acm_dns_records" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.0.0"

#   providers = { aws = aws.r53 }

#   create_certificate          = false
#   create_route53_records_only = true
#   validation_method           = "DNS"

#   zone_id               = local.zone_id
#   distinct_domain_names = module.acm_wildcard_cert.distinct_domain_names

#   acm_certificate_domain_validation_options = module.acm_wildcard_cert.acm_certificate_domain_validation_options
# }