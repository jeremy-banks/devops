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
  version = "5.59.0"

  name = "${local.resource_name_primary}-replicate"

  policy = data.aws_iam_policy_document.s3_tfstate_region_replicate.json
}

module "iam_role_tfstate_s3_region_replicate" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.59.0"

  trusted_role_services = ["s3.amazonaws.com"]

  create_role = true

  role_name           = "${local.resource_name_primary}-replicate"
  role_requires_mfa   = false
  attach_admin_policy = false

  custom_role_policy_arns = [module.iam_policy_tfstate_s3_region_replicate.arn]
}