data "aws_iam_policy_document" "iam_policy_tfstate_backend_crr" {
  provider = aws.management

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:ReplicateTags",
    ]
    resources = [
      "arn:aws:s3:::${local.resource_name_full_unique.primary}",
      "arn:aws:s3:::${local.resource_name_full_unique.primary}/*",
      "arn:aws:s3:::${local.resource_name_full_unique.failover}",
      "arn:aws:s3:::${local.resource_name_full_unique.failover}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
    resources = [
      module.kms_tfstate_backend_primary.key_arn,
      module.kms_tfstate_backend_failover.key_arn,
    ]
  }
}

module "iam_policy_tfstate_backend_crr" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version   = "6.2.1"
  providers = { aws = aws.management }

  name = "${local.resource_name.global}-crr"

  policy = data.aws_iam_policy_document.iam_policy_tfstate_backend_crr.json
}

module "iam_role_tfstate_backend_crr" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role"
  version   = "6.2.1"
  providers = { aws = aws.management }

  name            = "${local.resource_name.global}-crr"
  use_name_prefix = false

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      principals = [
        {
          type = "Service"
          identifiers = [
            "s3.amazonaws.com",
            "batchoperations.s3.amazonaws.com",
          ]
        }
      ]
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]
    }
  }

  policies = {
    replicate = module.iam_policy_tfstate_backend_crr.arn,
  }
}