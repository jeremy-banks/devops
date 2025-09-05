data "aws_iam_policy_document" "infrastructure" {
  provider = aws.management

  statement {
    sid    = "PreventR53Mutability"
    effect = "Deny"
    actions = [
      "route53:ActivateKeySigningKey",
      "route53:AssociateVPCWithHostedZone",
      "route53:Change*",
      "route53:Create*",
      "route53:DeactivateKeySigningKey",
      "route53:Delete*",
      "route53:DisableHostedZoneDNSSEC",
      "route53:DisassociateVPCFromHostedZone",
      "route53:EnableHostedZoneDNSSEC",
      "route53:Update*"
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

  statement {
    sid    = "PreventS3ArchiveMutability"
    effect = "Deny"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:AssociateAccessGrantsIdentityCenter",
      "s3:BypassGovernanceRetention",
      "s3:Create*",
      "s3:Delete*",
      "s3:DissociateAccessGrantsIdentityCenter",
      "s3:InitiateReplication",
      #   "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:PauseReplication",
      "s3:PutAccelerateConfiguration",
      "s3:PutAccess*",
      "s3:PutAccountPublicAccessBlock",
      "s3:PutAnalyticsConfiguration",
      "s3:PutBucket*",
      "s3:PutEncryptionConfiguration",
      "s3:PutIntelligentTieringConfiguration",
      "s3:PutInventoryConfiguration",
      "s3:PutJobTagging",
      "s3:PutLifecycleConfiguration",
      "s3:PutMetricsConfiguration",
      "s3:PutMultiRegionAccessPointPolicy",
      "s3:PutReplicationConfiguration",
      "s3:PutStorageLensConfiguration",
      "s3:PutStorageLensConfigurationTagging",
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:ReplicateTags",
      "s3:RestoreObject",
      "s3:SubmitMultiRegionAccessPointRoutes",
      "s3:TagResource",
      "s3:UntagResource",
      "s3:Update*",
      "ssm:SendCommand"
    ]
    resources = [
      "arn:aws:s3:::*archive*",
      "arn:aws:s3:::*archive*/*"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
      ]
    }
  }
}

resource "aws_organizations_policy" "infrastructure" {
  provider = aws.management

  name    = "infrastructure"
  content = data.aws_iam_policy_document.infrastructure.json
}

resource "aws_organizations_policy_attachment" "infrastructure" {
  provider = aws.management

  policy_id = aws_organizations_policy.infrastructure.id
  target_id = aws_organizations_organizational_unit.network.id
}