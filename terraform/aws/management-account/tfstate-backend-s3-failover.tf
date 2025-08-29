data "aws_iam_policy_document" "s3_tfstate_backend_failover" {
  provider = aws.management

  statement {
    sid    = "denyUnintendedAccessToBucket"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}",
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/*",
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = concat(
        [
          "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
          "${module.iam_role_tfstate_s3_region_replicate.arn}",
          "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.account_role_name}",
        ],
        [for user in module.iam_user_breakglass : user.arn]
      )
    }
  }

  statement {
    sid    = "denyUnintendedAccessToSuperAdmin"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.account_role_name}",
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.account_role_name}/*",
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = concat(
        [
          "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
          "${module.iam_role_tfstate_s3_region_replicate.arn}",
          "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.account_role_name}",
        ],
        [for user in module.iam_user_breakglass : user.arn]
      )
    }
  }

  statement {
    sid    = "denyUnintendedAccessToAdmin"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_role_name}",
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_role_name}/*",
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = concat(
        [
          "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
          "${module.iam_role_tfstate_s3_region_replicate.arn}",
          "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.account_role_name}",
          "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_role_name}",
        ],
        [for user in module.iam_user_breakglass : user.arn]
      )
    }
  }
}

module "s3_tfstate_backend_failover" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "5.5.0"
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

  attach_policy                             = true
  policy                                    = data.aws_iam_policy_document.s3_tfstate_backend_failover.json
  attach_deny_insecure_transport_policy     = true
  attach_require_latest_tls_policy          = true
  attach_deny_incorrect_encryption_headers  = true
  attach_deny_incorrect_kms_key_sse         = true
  allowed_kms_key_arn                       = module.kms_tfstate_backend_failover.key_arn
  attach_deny_unencrypted_object_uploads    = true
  attach_deny_ssec_encrypted_object_uploads = true
}

resource "aws_s3_bucket_replication_configuration" "s3_tfstate_backend_failover" {
  provider = aws.management_failover

  role   = module.iam_role_tfstate_s3_region_replicate.arn
  bucket = module.s3_tfstate_backend_failover.s3_bucket_id

  rule {
    id = "bidirectional-crr"

    status = "Enabled"

    destination {
      bucket        = module.s3_tfstate_backend_primary.s3_bucket_arn
      storage_class = "INTELLIGENT_TIERING"

      encryption_configuration { replica_kms_key_id = module.kms_tfstate_backend_primary.key_arn }
    }

    source_selection_criteria {
      sse_kms_encrypted_objects { status = "Enabled" }
    }
  }
}