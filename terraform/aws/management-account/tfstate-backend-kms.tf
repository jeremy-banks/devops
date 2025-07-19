data "aws_iam_policy_document" "kms_tfstate_backend" {
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

  # statement {
  #   sid    = "Explicit Deny Unintended Access"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat(
  #       [
  #         "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #         "arn:aws:iam::${data.aws_caller_identity.this.id}:role/s3-tfstate-region-replicate",
  #         "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
  #         "${module.iam_user_admin.iam_user_arn}",
  #       ],
  #       [for user in module.iam_user_breakglass : user.iam_user_arn]
  #     )
  #   }
  #   actions   = ["kms:*"]
  #   resources = ["*"]
  # }
}

module "kms_tfstate_backend_primary" {
  source  = "terraform-aws-modules/kms/aws"
  version = "4.0.0"

  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  aliases = ["${local.resource_name_stub_primary}-${var.this_slug}"]

  policy = data.aws_iam_policy_document.kms_tfstate_backend.json
}

module "kms_tfstate_backend_failover" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "4.0.0"
  providers = { aws = aws.management_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_tfstate_backend_primary.key_arn

  aliases = ["${local.resource_name_stub_failover}-${var.this_slug}"]

  policy = data.aws_iam_policy_document.kms_tfstate_backend.json
}