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

  statement {
    sid    = "Explicit Deny Unintended Access"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat(
        [
          "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
          "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
          "${module.iam_user_admin.iam_user_arn}"
        ],
        [for user in module.iam_user_breakglass : user.iam_user_arn]
      )
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

module "kms_tfstate_backend_primary" {
  source    = "terraform-aws-modules/kms/aws"
  version   = "3.1.1"
  providers = { aws = aws.org }

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
  version   = "3.1.1"
  providers = { aws = aws.org_failover }

  deletion_window_in_days = 30
  create_replica          = true
  primary_key_arn         = module.kms_tfstate_backend_primary.key_arn

  aliases = ["${local.resource_name_stub_failover}-${var.this_slug}"]

  policy = data.aws_iam_policy_document.kms_tfstate_backend.json
}

data "aws_iam_policy_document" "s3_tfstate_backend_primary" {
  statement {
    sid    = "denyUnintendedAccessToEntireBucket"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        ],
      [for user in module.iam_user_breakglass : user.iam_user_arn])
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_primary.s3_bucket_arn}",
      "${module.s3_tfstate_backend_primary.s3_bucket_arn}/*",
    ]
  }

  statement {
    sid    = "denyUnintendedAccessToSuperadmin"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        ],
      [for user in module.iam_user_breakglass : user.iam_user_arn])
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.superadmin}",
      "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.superadmin}/*",
    ]
  }

  statement {
    sid    = "denyUnintendedAccessToAdmin"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        "${module.iam_user_admin.iam_user_arn}",
        ],
      [for user in module.iam_user_breakglass : user.iam_user_arn])
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.admin}",
      "${module.s3_tfstate_backend_primary.s3_bucket_arn}/${var.admin_user_names.admin}/*",
    ]
  }
}

module "s3_tfstate_backend_primary" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "4.6.0"
  providers = { aws = aws.org }

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

  lifecycle_rule = [
    {
      id                                     = "intelligent-tier"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 7
      transition                             = [{ days = 1, storage_class = "INTELLIGENT_TIERING" }]
      noncurrent_version_transition          = [{ days = 1, storage_class = "INTELLIGENT_TIERING" }]
    }
  ]

  versioning = { enabled = true }

  replication_configuration = {
    role = module.iam_role_s3_tfstate_backend_primary_replicate_to_failover.iam_role_arn

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

data "aws_iam_policy_document" "s3_tfstate_backend_primary_replicate_to_failover" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = ["${module.s3_tfstate_backend_primary.s3_bucket_arn}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["${module.s3_tfstate_backend_primary.s3_bucket_arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = ["${module.s3_tfstate_backend_failover.s3_bucket_arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt"
    ]
    resources = [
      "${module.kms_tfstate_backend_primary.key_arn}",
      "${module.kms_tfstate_backend_failover.key_arn}"
    ]
  }
}

module "iam_policy_s3_tfstate_backend_primary_replicate_to_failover" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "s3-tfstate-backend-primary-replicate-to-failover"
  # path        = "/"
  # description = "My example policy"

  policy = data.aws_iam_policy_document.s3_tfstate_backend_primary_replicate_to_failover.json
}

module "iam_role_s3_tfstate_backend_primary_replicate_to_failover" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version   = "5.54.0"
  providers = { aws = aws.org }

  trusted_role_services = [
    "s3.amazonaws.com",
    "batchoperations.s3.amazonaws.com"
  ]

  create_role = true

  role_name           = "s3-primary-replicate-to-failover"
  role_requires_mfa   = false
  attach_admin_policy = false

  custom_role_policy_arns = [module.iam_policy_s3_tfstate_backend_primary_replicate_to_failover.arn]
}

data "aws_iam_policy_document" "s3_tfstate_backend_failover" {
  statement {
    sid    = "denyUnintendedAccessToEntireBucket"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        ],
      [for user in module.iam_user_breakglass : user.iam_user_arn])
    }
    actions = ["s3:*"]
    resources = [
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}",
      "${module.s3_tfstate_backend_failover.s3_bucket_arn}/*",
    ]
  }

  statement {
    sid    = "denyUnintendedAccessToSuperadmin"
    effect = "Deny"
    not_principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.this.id}:root",
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        ],
      [for user in module.iam_user_breakglass : user.iam_user_arn])
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
        "arn:aws:iam::${data.aws_caller_identity.this.id}:user/${var.admin_user_names.superadmin}",
        "${module.iam_user_admin.iam_user_arn}",
        ],
      [for user in module.iam_user_breakglass : user.iam_user_arn])
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
  version   = "4.6.0"
  providers = { aws = aws.org_failover }

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

  lifecycle_rule = [
    {
      id                                     = "intelligent-tier"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 7
      transition                             = [{ days = 1, storage_class = "INTELLIGENT_TIERING" }]
      noncurrent_version_transition          = [{ days = 1, storage_class = "INTELLIGENT_TIERING" }]
    }
  ]

  versioning = { enabled = true }

  attach_policy                            = true
  policy                                   = data.aws_iam_policy_document.s3_tfstate_backend_failover.json
  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = module.kms_tfstate_backend_failover.key_arn
}