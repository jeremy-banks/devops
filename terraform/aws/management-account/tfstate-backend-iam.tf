data "aws_iam_policy_document" "s3_tfstate_region_replicate" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::${local.resource_name_stub_primary}-tfstate-${local.unique_id}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["arn:aws:s3:::${local.resource_name_stub_primary}-tfstate-${local.unique_id}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = ["arn:aws:s3:::${local.resource_name_stub_failover}-tfstate-${local.unique_id}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]
    resources = ["arn:aws:kms:*:${data.aws_caller_identity.this.id}:key/*"]
    condition {
      test     = "StringLike"
      variable = "kms:ResourceAliases"
      values   = [
        "alias/${local.resource_name_stub_primary}-tfstate",
        "alias/${local.resource_name_stub_failover}-tfstate",
      ]
    }
  }
}

module "iam_policy_tfstate_s3_region_replicate" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.59.0"

  name = "tfstate-s3-region-replicate"

  policy = data.aws_iam_policy_document.s3_tfstate_region_replicate.json
}

module "iam_role_tfstate_s3_region_replicate" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.59.0"

  trusted_role_services = [
    "s3.amazonaws.com",
    # "batchoperations.s3.amazonaws.com"
  ]

  create_role = true

  role_name           = "tfstate-s3-region-replicate"
  role_requires_mfa   = false
  attach_admin_policy = false

  custom_role_policy_arns = [module.iam_policy_tfstate_s3_region_replicate.arn]
}