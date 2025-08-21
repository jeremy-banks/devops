module "s3_failover" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "5.4.0"
  providers = { aws = aws.this_failover }

  bucket = local.resource_name_failover_globally_unique

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms_failover.key_arn
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

  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = module.kms_failover.key_arn
}

resource "aws_s3_bucket_replication_configuration" "s3_failover" {
  provider = aws.this_failover

  role   = module.iam_role_s3_crr.arn
  bucket = module.s3_failover.s3_bucket_id

  rule {
    id = "bidirectional-crr"

    status = "Enabled"

    destination {
      bucket        = module.s3_primary.s3_bucket_arn
      storage_class = "INTELLIGENT_TIERING"

      encryption_configuration { replica_kms_key_id = module.kms_primary.key_arn }
    }

    source_selection_criteria {
      sse_kms_encrypted_objects { status = "Enabled" }
    }
  }
}