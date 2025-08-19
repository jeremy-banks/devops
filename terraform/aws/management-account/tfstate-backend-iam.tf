data "aws_iam_policy_document" "s3_tfstate_region_replicate" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::${local.resource_name_primary_globally_unique}"]
  }
  statement {
    effect = "Allow"
    actions = [
      # "s3:GetObjectVersion",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["arn:aws:s3:::${local.resource_name_primary_globally_unique}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = ["arn:aws:s3:::${local.resource_name_failover_globally_unique}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:ListAliases",
      "kms:ListKeys",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:GetKeyRotationStatus",
      "kms:GetPublicKey",
      "kms:ReEncrypt*",
      "kms:Sign",
      "kms:Verify",
    ]
    resources = [
      module.kms_tfstate_backend_primary.key_arn,
      module.kms_tfstate_backend_failover.key_arn,
    ]
  }
}

module "iam_policy_tfstate_s3_region_replicate" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.1.1"

  name = "${local.resource_name_primary}-replicate"

  policy = data.aws_iam_policy_document.s3_tfstate_region_replicate.json
}

module "iam_role_tfstate_s3_region_replicate" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.1.1"

  name            = "${local.resource_name_primary}-replicate"
  use_name_prefix = false

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      principals = [
        {
          type = "Service"
          identifiers = [
            "s3.amazonaws.com",
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
    replicate = module.iam_policy_tfstate_s3_region_replicate.arn,
  }
}