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
    sid    = "Explicit Deny Unintended Access"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat(
        [
          "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
          "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.superuser_names.superadmin}",
          "${module.iam_user_admin.iam_user_arn}"
        ],
        [for user in module.iam_user_breakglass : user.iam_user_arn]
      )
    }
    actions   = ["kms:*"]
    resources = ["*"]
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