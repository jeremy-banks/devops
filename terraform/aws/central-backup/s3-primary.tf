data "aws_iam_policy_document" "s3_primary" {
  statement {
    sid    = "allowOrgRolesPutObjectInsideAccountPrefix"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${module.s3_primary.s3_bucket_arn}/${"$${aws:PrincipalAccount}"}/*"]
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

module "s3_primary" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "5.5.0"
  providers = { aws = aws.shared_services_prd }

  bucket = local.resource_name_primary_globally_unique

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms_primary.key_arn
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
  policy                                    = data.aws_iam_policy_document.s3_primary.json
  attach_deny_insecure_transport_policy     = true
  attach_require_latest_tls_policy          = true
  attach_deny_incorrect_encryption_headers  = true
  attach_deny_incorrect_kms_key_sse         = true
  allowed_kms_key_arn                       = module.kms_primary.key_arn
  attach_deny_unencrypted_object_uploads    = true
  attach_deny_ssec_encrypted_object_uploads = true
}

resource "aws_s3_bucket_replication_configuration" "s3_primary" {
  provider = aws.shared_services_prd

  count = var.create_failover_region_network ? 1 : 0

  role   = module.iam_role_s3_crr[0].arn
  bucket = module.s3_primary.s3_bucket_id

  rule {
    id = "bidirectional-crr"

    status = "Enabled"

    destination {
      bucket        = module.s3_failover[0].s3_bucket_arn
      storage_class = "INTELLIGENT_TIERING"

      encryption_configuration { replica_kms_key_id = module.kms_failover[0].key_arn }
    }

    source_selection_criteria {
      sse_kms_encrypted_objects { status = "Enabled" }
    }
  }
}