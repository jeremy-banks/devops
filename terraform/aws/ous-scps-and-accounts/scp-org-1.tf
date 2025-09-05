data "aws_iam_policy_document" "org_1" {
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

  # no 00000
  statement {
    sid    = "DenySecGrpActionUsing00000CIDR"
    effect = "Deny"
    actions = [
      "ec2:AuthorizeSecurityGroup*",
      "ec2:RevokeSecurityGroup*",
      "ec2:UpdateSecurityGroup*",
    ]
    resources = ["*"]
    condition {
      test     = "IpAddress"
      variable = "ec2:CIDR"
      values   = ["0.0.0.0/0"]
    }
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
      ]
    }
  }

  # acm controls
  statement {
    sid    = "PreventACMMutability"
    effect = "Deny"
    actions = [
      "acm:AddTagsToCertificate",
      "acm:DeleteCertificate",
      "acm:ImportCertificate",
      "acm:PutAccountConfiguration",
      "acm:RemoveTagsFromCertificate",
      "acm:RenewCertificate",
      "acm:RequestCertificate",
      "acm:ResendValidationEmail",
      "acm:RevokeCertificate",
      "acm:UpdateCertificateOptions",
      "ec2:AssociateEnclaveCertificateIamRole",
      "ec2:DisassociateEnclaveCertificateIamRole",
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
      ]
    }
  }

  # iam controls
  statement {
    sid    = "PreventIAMMutability"
    effect = "Deny"
    actions = [
      "codestar:CreateUserProfile",
      "codestar:DeleteUserProfile",
      "codestar:UpdateUserProfile",
      "ec2:AssociateEnclaveCertificateIamRole",
      "ec2:DisassociateEnclaveCertificateIamRole",
      "iam:Add*",
      "iam:Attach*",
      "iam:ChangePassword",
      "iam:Create*",
      "iam:DeactivateMFADevice",
      "iam:Delete*",
      "iam:Detach*",
      "iam:Disable*",
      "iam:Enable*",
      "iam:PassRole",
      "iam:Put*",
      "iam:Remove*",
      "iam:ResetServiceSpecificCredential",
      "iam:ResyncMFADevice",
      "iam:Set*",
      "iam:Tag*",
      "iam:Untag*",
      "iam:Update*",
      "iam:Upload*",
      "ssm:UpdateManagedInstanceRole",
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalArn"
      values   = ["$${aws:ResourceArn}"]
    }
    condition {
      test     = "StringNotLikeIfExists"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}"]
    }
  }

  # kms controls
  statement {
    sid    = "PreventKMSMutability"
    effect = "Deny"
    actions = [
      "events:CreateArchive",
      "events:UpdateArchive",
      "kinesis:StartStreamEncryption",
      "kinesis:StopStreamEncryption",
      "kms:CancelKeyDeletion",
      "kms:ConnectCustomKeyStore",
      "kms:Create*",
      #   "kms:Decrypt",
      "kms:Delete*",
      "kms:DeriveSharedSecret",
      "kms:Disable*",
      "kms:DisconnectCustomKeyStore",
      "kms:Enable*",
      #   "kms:Encrypt",
      #   "kms:GenerateDataKey",
      #   "kms:GenerateDataKeyPair",
      #   "kms:GenerateDataKeyPairWithoutPlaintext",
      #   "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GenerateMac",
      "kms:GenerateRandom",
      "kms:ImportKeyMaterial",
      "kms:PutKeyPolicy",
      #   "kms:ReEncryptFrom",
      #   "kms:ReEncryptTo",
      "kms:ReplicateKey",
      "kms:RetireGrant",
      "kms:RevokeGrant",
      "kms:RotateKeyOnDemand",
      "kms:ScheduleKeyDeletion",
      "kms:Sign",
      "kms:SynchronizeMultiRegionKey",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:Update*",
      "kms:Verify*"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
      ]
    }
  }
}

resource "aws_organizations_policy" "org_1" {
  provider = aws.management

  name    = "org-1"
  content = data.aws_iam_policy_document.org_1.json
}

resource "aws_organizations_policy_attachment" "org_1" {
  provider = aws.management

  policy_id = aws_organizations_policy.org_1.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}