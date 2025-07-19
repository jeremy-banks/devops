data "aws_iam_policy_document" "s3_tfstate_backend_primary" {
  # statement {
  #   sid    = "denyUnintendedAccessToEntireBucket"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat([
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:role/s3-tfstate-region-replicate",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
  #       ],
  #     [for user in module.iam_user_breakglass : user.iam_user_arn])
  #   }
  #   actions = ["s3:*"]
  #   resources = [
  #     "${module.s3_tfstate_backend_primary.s3_bucket_arn}",
  #     "${module.s3_tfstate_backend_primary.s3_bucket_arn}/*",
  #   ]
  # }

  # statement {
  #   sid    = "denyUnintendedAccessToSuperadmin"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat([
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:role/s3-tfstate-region-replicate",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
  #       ],
  #     [for user in module.iam_user_breakglass : user.iam_user_arn])
  #   }
  #   actions = ["s3:*"]
  #   resources = [
  #     "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.superadmin}",
  #     "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.superadmin}/*",
  #   ]
  # }

  # statement {
  #   sid    = "denyUnintendedAccessToAdmin"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat([
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:role/s3-tfstate-region-replicate",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
  #       "${module.iam_user_admin.iam_user_arn}",
  #       ],
  #     [for user in module.iam_user_breakglass : user.iam_user_arn])
  #   }
  #   actions = ["s3:*"]
  #   resources = [
  #     "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.admin}",
  #     "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.admin}/*",
  #   ]
  # }
}

module "s3_tfstate_backend_primary" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.2.0"

  bucket = "${local.resource_name_stub_primary}-tfstate-storage-blob-${local.unique_id}"

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms_tfstate_backend_primary.key_arn
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

  replication_configuration = {
    role = module.iam_role_s3_tfstate_region_replicate.iam_role_arn

    rules = [
      {
        id     = "replicate-everything"
        status = "Enabled"

        delete_marker_replication = true

        source_selection_criteria = {
          replica_modifications     = { status = "Enabled" }
          sse_kms_encrypted_objects = { enabled = true }
        }

        destination = {
          bucket             = module.s3_tfstate_backend_failover.s3_bucket_arn
          storage_class      = "INTELLIGENT_TIERING"
          replica_kms_key_id = module.kms_tfstate_backend_failover.key_arn
        }
      },
    ]
  }

  attach_policy                            = true
  policy                                   = data.aws_iam_policy_document.s3_tfstate_backend_primary.json
  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = module.kms_tfstate_backend_primary.key_arn
}

data "aws_iam_policy_document" "s3_tfstate_backend_failover" {
  # statement {
  #   sid    = "denyUnintendedAccessToEntireBucket"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat([
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:role/s3-tfstate-region-replicate",
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

  # statement {
  #   sid    = "denyUnintendedAccessToSuperadmin"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat([
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:role/s3-tfstate-region-replicate",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
  #       ],
  #     [for user in module.iam_user_breakglass : user.iam_user_arn])
  #   }
  #   actions = ["s3:*"]
  #   resources = [
  #     "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.superadmin}",
  #     "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.superadmin}/*",
  #   ]
  # }

  # statement {
  #   sid    = "denyUnintendedAccessToAdmin"
  #   effect = "Deny"
  #   not_principals {
  #     type = "AWS"
  #     identifiers = concat([
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:role/s3-tfstate-region-replicate",
  #       "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
  #       "${module.iam_user_admin.iam_user_arn}",
  #       ],
  #     [for user in module.iam_user_breakglass : user.iam_user_arn])
  #   }
  #   actions = ["s3:*"]
  #   resources = [
  #     "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.admin}",
  #     "${module.s3_tfstate_backend_failover.s3_bucket_arn}/${var.admin_user_names.admin}/*",
  #   ]
  # }
}

module "s3_tfstate_backend_failover" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "5.2.0"
  providers = { aws = aws.management_failover }

  bucket = "${local.resource_name_stub_failover}-tfstate-storage-blob-${local.unique_id}"

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