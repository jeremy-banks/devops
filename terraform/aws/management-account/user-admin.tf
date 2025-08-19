data "aws_iam_policy_document" "iam_user_admin" {
  statement {
    sid       = "AllowAssumeRolesInOrg"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${var.admin_user_names.admin}"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [aws_organizations_organization.this.id]
    }
  }

  statement {
    sid     = "AllowUseOfTerraformStateS3Bucket"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${local.resource_name_primary_globally_unique}/${var.admin_user_names.admin}",
      "arn:aws:s3:::${local.resource_name_primary_globally_unique}/${var.admin_user_names.admin}/*",
      "arn:aws:s3:::${local.resource_name_failover_globally_unique}/${var.admin_user_names.admin}",
      "arn:aws:s3:::${local.resource_name_failover_globally_unique}/${var.admin_user_names.admin}/*",
    ]
  }

  statement {
    sid    = "AllowUseOfTerraformStateS3BucketKMS"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DeriveSharedSecret",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:GenerateMac",
      "kms:GetPublicKey",
      "kms:ReEncrypt*",
      "kms:Sign",
      "kms:Verify",
      "kms:VerifyMac",
    ]
    resources = [
      module.kms_tfstate_backend_primary.key_arn,
      module.kms_tfstate_backend_failover.key_arn,
    ]
  }
}

module "iam_user_admin_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.1.1"

  name = var.admin_user_names.admin

  policy = data.aws_iam_policy_document.iam_user_admin.json
}

module "iam_user_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "6.1.1"

  name = var.admin_user_names.admin

  create_login_profile = false
  create_access_key    = true

  policies = {
    admin-user    = module.iam_user_admin_policy.arn,
    org-read-only = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess",
  }
}