# data "aws_iam_policy_document" "org_2" {
#   provider = aws.management

#   statement {
#     sid    = "PreventR53Mutability"
#     effect = "Deny"
#     actions = [
#       "route53:ActivateKeySigningKey",
#       "route53:AssociateVPCWithHostedZone",
#       "route53:ChangeCidrCollection",
#       "route53:ChangeResourceRecordSets",
#       "route53:ChangeTagsForResource",
#       "route53:CreateCidrCollection",
#       "route53:CreateHealthCheck",
#       "route53:CreateHostedZone",
#       "route53:CreateKeySigningKey",
#       "route53:CreateQueryLoggingConfig",
#       "route53:CreateReusableDelegationSet",
#       "route53:CreateTrafficPolicy",
#       "route53:CreateTrafficPolicyInstance",
#       "route53:CreateTrafficPolicyVersion",
#       "route53:CreateVPCAssociationAuthorization",
#       "route53:DeactivateKeySigningKey",
#       "route53:DeleteCidrCollection",
#       "route53:DeleteHealthCheck",
#       "route53:DeleteHostedZone",
#       "route53:DeleteKeySigningKey",
#       "route53:DeleteQueryLoggingConfig",
#       "route53:DeleteReusableDelegationSet",
#       "route53:DeleteTrafficPolicy",
#       "route53:DeleteTrafficPolicyInstance",
#       "route53:DeleteVPCAssociationAuthorization",
#       "route53:DisableHostedZoneDNSSEC",
#       "route53:DisassociateVPCFromHostedZone",
#       "route53:EnableHostedZoneDNSSEC",
#       "route53:UpdateHealthCheck",
#       "route53:UpdateHostedZoneComment",
#       "route53:UpdateTrafficPolicyComment",
#       "route53:UpdateTrafficPolicyInstance"
#     ]
#     resources = ["*"]
#     condition {
#       test     = "StringNotEquals"
#       variable = "aws:PrincipalArn"
#       values = [
#         "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
#       ]
#     }
#   }

#   statement {
#     sid    = "PreventS3ArchiveMutability"
#     effect = "Deny"
#     actions = [
#       "s3:AbortMultipartUpload",
#       "s3:AssociateAccessGrantsIdentityCenter",
#       "s3:BypassGovernanceRetention",
#       "s3:Create*",
#       "s3:Delete*",
#       "s3:DissociateAccessGrantsIdentityCenter",
#       "s3:InitiateReplication",
#       #   "s3:ObjectOwnerOverrideToBucketOwner",
#       "s3:PauseReplication",
#       "s3:PutAccelerateConfiguration",
#       "s3:PutAccess*",
#       "s3:PutAccountPublicAccessBlock",
#       "s3:PutAnalyticsConfiguration",
#       "s3:PutBucket*",
#       "s3:PutEncryptionConfiguration",
#       "s3:PutIntelligentTieringConfiguration",
#       "s3:PutInventoryConfiguration",
#       "s3:PutJobTagging",
#       "s3:PutLifecycleConfiguration",
#       "s3:PutMetricsConfiguration",
#       "s3:PutMultiRegionAccessPointPolicy",
#       "s3:PutReplicationConfiguration",
#       "s3:PutStorageLensConfiguration",
#       "s3:PutStorageLensConfigurationTagging",
#       "s3:ReplicateDelete",
#       "s3:ReplicateObject",
#       "s3:ReplicateTags",
#       "s3:RestoreObject",
#       "s3:SubmitMultiRegionAccessPointRoutes",
#       "s3:TagResource",
#       "s3:UntagResource",
#       "s3:Update*",
#       "ssm:SendCommand"
#     ]
#     resources = [
#       "arn:aws:s3:::*archive*",
#       "arn:aws:s3:::*archive*/*"
#     ]
#     condition {
#       test     = "StringNotEquals"
#       variable = "aws:PrincipalArn"
#       values = [
#         "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
#       ]
#     }
#   }
# }

# resource "aws_organizations_policy" "org_2" {
#   provider = aws.management

#   name    = "org-2"
#   content = data.aws_iam_policy_document.org_2.json
# }

# resource "aws_organizations_policy_attachment" "org_2" {
#   provider = aws.management

#   policy_id = aws_organizations_policy.org_2.id
#   target_id = data.aws_organizations_organization.this.roots[0].id
# }