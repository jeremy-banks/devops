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
    }
  }
}

#iam role for data transfer


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
    }
  }
}