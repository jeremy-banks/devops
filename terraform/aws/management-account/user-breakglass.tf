data "aws_iam_policy_document" "iam_user_breakglass" {
  statement {
    sid       = "AllowAssumeRolesInOrg"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${var.superuser_names.admin}"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.this.id]
    }
  }

  statement {
    sid     = "AllowUseOfTerraformStateS3Bucket"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${local.resource_name_stub_primary}-tfstate-storage-blob-${local.unique_id}/${var.superuser_names.admin}",
      "arn:aws:s3:::${local.resource_name_stub_primary}-tfstate-storage-blob-${local.unique_id}/${var.superuser_names.admin}/*",
      "arn:aws:s3:::${local.resource_name_stub_failover}-tfstate-storage-blob-${local.unique_id}/${var.superuser_names.admin}",
      "arn:aws:s3:::${local.resource_name_stub_failover}-tfstate-storage-blob-${local.unique_id}/${var.superuser_names.admin}/*",
    ]
  }

  statement {
    sid    = "AllowUseOfTerraformStateS3BucketKMS"
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
      "kms:Decrypt",
      "kms:DeriveSharedSecret",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:GenerateMac",
      "kms:GetPublicKey",
      "kms:ReEncrypt*",
      "kms:ReEncrypt*",
      "kms:Sign",
      "kms:Verify",
      "kms:VerifyMac",
    ]
    resources = [
      "arn:aws:kms:${var.region.primary}:${data.aws_caller_identity.this.id}:alias/${local.resource_name_stub_primary}-${var.this_slug}",
      "arn:aws:kms:${var.region.failover}:${data.aws_caller_identity.this.id}:alias/${local.resource_name_stub_failover}-${var.this_slug}",
    ]
  }
}

module "iam_user_breakglass_policy" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version   = "5.54.0"
  providers = { aws = aws.org }

  name = "breakglass"

  policy = data.aws_iam_policy_document.iam_user_breakglass.json
}

module "iam_user_breakglass" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-user"
  version   = "5.54.0"
  providers = { aws = aws.org }

  count = 3

  name = "${var.superuser_names.breakglass}${count.index + 1}"

  create_iam_user_login_profile = true
  create_iam_access_key         = false
  policy_arns = [
    module.iam_user_admin_policy.arn,
    "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess",
  ]
}
