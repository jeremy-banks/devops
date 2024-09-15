#primary bucket
module "s3_primary" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"
  providers = { aws = aws.project_demo_nonprod }

  bucket = "${local.resource_name_stub_env}-storage-blob-primary"

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

  lifecycle_rule = [
    {
      id      = "intelligent-tier"
      enabled = true
      abort_incomplete_multipart_upload_days = 7

      transition = [ { storage_class = "INTELLIGENT_TIERING" } ]
      noncurrent_version_transition = [ { storage_class = "INTELLIGENT_TIERING" } ]
    }
  ]

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
          bucket        = module.s3_failover.s3_bucket_arn
          storage_class = "INTELLIGENT_TIERING"
          replica_kms_key_id = module.kms_failover.key_arn
        }
      },
    ]
  }

  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = true
  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = module.kms_primary.key_arn
  attach_deny_unencrypted_object_uploads   = true
}

#iam policy for data transfer
module "iam_policy_s3_primary_replicate_to_failover" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.44.0"
  providers = { aws = aws.project_demo_nonprod }

  name  = "s3-primary-replicate-to-failover"

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

#iam role for data transfer
module "iam_role_s3_primary_replicate_to_failover" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.44.0"
  providers = { aws = aws.project_demo_nonprod }

  trusted_role_services = [
    "s3.amazonaws.com",
    "batchoperations.s3.amazonaws.com"
  ]

  create_role = true

  role_name = "s3-primary-replicate-to-failover"
  role_requires_mfa = false
  attach_admin_policy = false

  custom_role_policy_arns = [
    module.iam_policy_s3_primary_replicate_to_failover.arn
  ]
}

#failover bucket
module "s3_failover" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"
  providers = { aws = aws.project_demo_nonprod_failover }

  bucket = "${local.resource_name_stub_env}-storage-blob-failover"

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

  lifecycle_rule = [
    {
      id      = "intelligent-tier"
      enabled = true
      abort_incomplete_multipart_upload_days = 7

      transition = [ { storage_class = "INTELLIGENT_TIERING" } ]
      noncurrent_version_transition = [ { storage_class = "INTELLIGENT_TIERING" } ]
    }
  ]

  versioning = { enabled = true }

  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = true
  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  allowed_kms_key_arn                      = module.kms_failover.key_arn
  attach_deny_unencrypted_object_uploads   = true
}