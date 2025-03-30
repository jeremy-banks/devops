data "aws_iam_policy_document" "org_root" {
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html#example-scp-leave-org
  statement {
    sid       = "PreventMemberAccountsFromLeavingTheOrganization"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
    effect    = "Deny"
  }

  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_ec2.html#example-ec2-3
  statement {
    sid       = "PreventDisablingOfDefaultAmazonEBSEncryption"
    effect    = "Deny"
    actions   = ["ec2:DisableEbsEncryptionByDefault"]
    resources = ["*"]
  }

  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_s3.html#example-s3-1
  statement {
    sid       = "PreventAmazonS3UnencryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }

  # https://aws.amazon.com/blogs/mt/identity-guide-preventive-controls-with-aws-identity-scps/
  statement {
    sid       = "PreventRDSUnencryptedDBCreation"
    effect    = "Deny"
    actions   = ["rds:CreateDBInstance"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "rds:StorageEncrypted"
      values   = ["false"]
    }
  }
  statement {
    sid       = "PreventEFSUnencryptedClusterCreation"
    effect    = "Deny"
    actions   = ["elasticfilesystem:CreateFileSystem"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "elasticfilesystem:Encrypted"
      values   = ["false"]
    }
  }
  statement {
    sid       = "PreventKMSDeleteUnlessSuperAdmin"
    effect    = "Deny"
    actions   = ["kms:ScheduleKeyDeletion", "kms:Delete"]
    resources = ["*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/${var.admin_user_names.superadmin}",
        "arn:aws:iam::*:role/${var.superadmin_role_name}",
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [
        "${data.aws_organizations_organization.this.id}",
      ]
    }
  }

  # S3 bucket controls from terraform modules
  statement {
    sid       = "PreventS3OutdatedTLS"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["*"]
    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values   = ["1.2"]
    }
  }
  statement {
    sid       = "PreventS3InsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_organizations_policy" "org_root" {
  name    = "org-root"
  content = data.aws_iam_policy_document.org_root.json
}

resource "aws_organizations_policy_attachment" "org_root" {
  policy_id = aws_organizations_policy.org_root.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_policy_attachment" "management_account" {
  policy_id = aws_organizations_policy.org_root.id
  target_id = data.aws_caller_identity.this.account_id
}