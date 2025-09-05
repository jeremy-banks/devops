data "aws_iam_policy_document" "org_2" {
  provider = aws.management

  # prevent external sharing
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_ram.html#example_ram_1
  statement {
    effect = "Deny"
    actions = [
      "ram:CreateResourceShare",
      "ram:UpdateResourceShare"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "ram:RequestedAllowsExternalPrincipals"
      values   = ["true"]
    }
  }

  # prevent insecure in-transit
  statement {
    # sid       = "PreventS3OutdatedTLS"
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
    # sid       = "PreventS3InsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  # prevent unencrypted at-rest
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_s3.html#example-s3-1
  statement {
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }
  statement {
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }

  # https://aws.amazon.com/blogs/mt/identity-guide-preventive-controls-with-aws-identity-scps/
  statement {
    # sid       = "PreventRDSUnencryptedDBCreation"
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
    # sid       = "PreventEFSUnencryptedClusterCreation"
    effect    = "Deny"
    actions   = ["elasticfilesystem:CreateFileSystem"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "elasticfilesystem:Encrypted"
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

  # prevent deleting flow logs
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_vpc.html#example_vpc_1
  statement {
    effect = "Deny"
    actions = [
      "ec2:DeleteFlowLogs",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream"
    ]
    resources = ["*"]
  }

  # prevent adding internet access to VPC
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_vpc.html#example_vpc_2
  statement {
    effect = "Deny"
    actions = [
      "ec2:AttachInternetGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateEgressOnlyInternetGateway",
      "ec2:CreateVpcPeeringConnection",
      "ec2:AcceptVpcPeeringConnection",
      "globalaccelerator:Create*",
      "globalaccelerator:Update*"
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "org_2" {
  provider = aws.management

  name    = "org-2"
  content = data.aws_iam_policy_document.org_2.json
}

resource "aws_organizations_policy_attachment" "org_2" {
  provider = aws.management

  policy_id = aws_organizations_policy.org_2.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}