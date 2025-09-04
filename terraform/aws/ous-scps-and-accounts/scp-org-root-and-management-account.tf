data "aws_iam_policy_document" "org_root" {
  provider = aws.management

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
    sid       = "PreventKMSCreateUnlessSuperAdmin"
    effect    = "Deny"
    actions   = ["kms:CreateKey"]
    resources = ["*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
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

  statement {
    sid    = "PreventKMSWriteUnlessSuperAdmin"
    effect = "Deny"
    not_actions = [
      "kms:CreateGrant",
      "kms:DescribeCustomKeyStores",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:GetParametersForImport",
      "kms:GetPublicKey",
      "kms:ListAliases",
      "kms:ListGrants",
      "kms:ListKeyPolicies",
      "kms:ListKeyRotations",
      "kms:ListKeys",
      "kms:ListResourceTags",
      "kms:ListRetirableGrants",
      "kms:PutKeyPolicy",
      "kms:RetireGrant",
      "kms:RevokeGrant"
    ]
    resources = ["arn:aws:kms:*:*:key/*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
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

  statement {
    sid    = "PreventACMCreateUnlessSuperAdmin"
    effect = "Deny"
    actions = [
      "acm:ImportCertificate",
      "acm:RequestCertificate",
    ]
    resources = ["*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
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

  statement {
    sid    = "PreventACMWriteUnlessSuperAdmin"
    effect = "Deny"
    not_actions = [
      "acm:DescribeCertificate",
      "acm:ExportCertificate",
      "acm:GetAccountConfiguration",
      "acm:GetCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",
    ]
    resources = ["arn:aws:kms:*:*:key/*"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
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
  provider = aws.management

  name    = "org-root"
  content = data.aws_iam_policy_document.org_root.json
}

resource "aws_organizations_policy_attachment" "org_root" {
  provider = aws.management

  policy_id = aws_organizations_policy.org_root.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}