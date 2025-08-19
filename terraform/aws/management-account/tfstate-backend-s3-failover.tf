data "aws_iam_policy_document" "s3_tfstate_backend_failover" {
  # statement {
  #   sid    = "denyUnintendedAccessToEntireBucket"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat([
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #       "${module.iam_role_tfstate_s3_region_replicate.arn}",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
  #       ],
  #     [for user in module.iam_user_breakglass : user.iam_user_arn])
  #   }
  #   actions = ["s3:*"]
  #   resources = [
  #     "${module.s3_tfstate_backend_failover.s3_bucket_arn}",
  #     "${module.s3_tfstate_backend_failover.s3_bucket_arn}/*",
  #   ]
  # }

  statement {
    sid    = "denyUnintendedAccessToSuperadmin"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
        "${module.iam_role_tfstate_s3_region_replicate.arn}",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        ],
      [for user in module.iam_user_breakglass : user.arn])
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.superadmin}",
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.superadmin}/*",
    ]
  }

  statement {
    sid    = "denyUnintendedAccessToAdmin"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
        "${module.iam_role_tfstate_s3_region_replicate.arn}",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        "${module.iam_user_admin.arn}",
        ],
      [for user in module.iam_user_breakglass : user.arn])
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.admin}",
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.admin}/*",
    ]
  }
}

module "s3_tfstate_backend_failover" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "5.2.0"
  providers = { aws = aws.management_failover }

  bucket = local.resource_name_failover_globally_unique

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms_tfstate_backend_failover.key_arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  intelligent_tiering = {
    general = {
      status  = "Enabled"
      filter  = { prefix = "/" }
      tiering = { ARCHIVE_ACCESS = { days = 90 } }
    }
  }

  versioning = { enabled = true }

  attach_policy                            = true
  policy                                   = data.aws_iam_policy_document.s3_tfstate_backend_failover.json
  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = module.kms_tfstate_backend_failover.key_arn
}

resource "aws_s3_bucket_replication_configuration" "s3_tfstate_backend_failover" {
  provider = aws.management_failover
#   provider = aws.central
  # Must have bucket versioning enabled first
#   depends_on = [aws_s3_bucket_versioning.source]

  role   = module.iam_role_tfstate_s3_region_replicate.arn
  bucket = module.s3_tfstate_backend_failover.s3_bucket_id

  rule {
    id = "failover-to-primary"

    # filter {
    #   prefix = "example"
    # }

    status = "Enabled"

    destination {
      bucket        = module.s3_tfstate_backend_primary.s3_bucket_arn
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}