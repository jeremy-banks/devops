module "s3_primary" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "5.4.0"
  providers = { aws = aws.this }

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

  replication_configuration = {
    role = module.iam_role_s3_primary_replicate_to_failover.iam_role_arn

    rules = [
      {
        id     = "replicate-everything"
        status = "Enabled"

        delete_marker_replication = true

        source_selection_criteria = {
          replica_modifications = {
            status = "Enabled"
          }
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          bucket             = module.s3_failover.s3_bucket_arn
          storage_class      = "INTELLIGENT_TIERING"
          replica_kms_key_id = module.kms_failover.key_arn
        }
      },
    ]
  }

  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = module.kms_primary.key_arn
}

module "iam_policy_s3_primary_replicate_to_failover" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version   = "5.59.0"
  providers = { aws = aws.this }

  name = "s3-tfstate-region-replicate"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
        "Effect":"Allow",
        "Action":[
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Resource":"${module.s3_primary.s3_bucket_arn}"
    },
    {
        "Effect":"Allow",
        "Action":[
          "s3:GetObjectVersion",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ],
        "Resource":"${module.s3_primary.s3_bucket_arn}/*"
    },
    {
        "Effect":"Allow",
        "Action":[
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Resource":"${module.s3_failover.s3_bucket_arn}/*"
    },
    {
        "Effect":"Allow",
        "Action":[
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:Decrypt"
        ],
        "Resource":[
          "${module.kms_primary.key_arn}",
          "${module.kms_failover.key_arn}"
        ]
    }
  ]
}
EOF
}

module "iam_role_s3_primary_replicate_to_failover" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version   = "5.59.0"
  providers = { aws = aws.this }

  trusted_role_services = [
    "s3.amazonaws.com",
    "batchoperations.s3.amazonaws.com"
  ]

  create_role = true

  role_name           = "s3-tfstate-region-replicate"
  role_requires_mfa   = false
  attach_admin_policy = false

  custom_role_policy_arns = [
    module.iam_policy_s3_primary_replicate_to_failover.arn
  ]
}

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