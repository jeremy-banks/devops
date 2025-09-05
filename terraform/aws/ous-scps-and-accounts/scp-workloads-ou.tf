data "aws_iam_policy_document" "workloads_ou" {
  provider = aws.management

  statement {
    sid       = "DenyRegionInteraction"
    actions   = ["account:EnableRegion", "account:DisableRegion"]
    resources = ["*"]
    effect    = "Deny"
  }

  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_config.html#example_config_1
  statement {
    sid    = "PreventUsersFromDisablingAWSConfigOrChangingItsRules"
    effect = "Deny"
    actions = [
      "config:DeleteConfigRule",
      "config:DeleteConfigurationRecorder",
      "config:DeleteDeliveryChannel",
      "config:StopConfigurationRecorder",
    ]
    resources = ["*"]
  }

  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_guardduty.html#example_guardduty_1
  statement {
    sid    = "PreventUsersFromDisablingGuardDutyOrModifyingItsConfiguration"
    effect = "Deny"
    actions = [
      "guardduty:AcceptInvitation",
      "guardduty:ArchiveFindings",
      "guardduty:CreateDetector",
      "guardduty:CreateFilter",
      "guardduty:CreateIPSet",
      "guardduty:CreateMembers",
      "guardduty:CreatePublishingDestination",
      "guardduty:CreateSampleFindings",
      "guardduty:CreateThreatIntelSet",
      "guardduty:DeclineInvitations",
      "guardduty:DeleteDetector",
      "guardduty:DeleteFilter",
      "guardduty:DeleteInvitations",
      "guardduty:DeleteIPSet",
      "guardduty:DeleteMembers",
      "guardduty:DeletePublishingDestination",
      "guardduty:DeleteThreatIntelSet",
      "guardduty:DisassociateFromMasterAccount",
      "guardduty:DisassociateMembers",
      "guardduty:InviteMembers",
      "guardduty:StartMonitoringMembers",
      "guardduty:StopMonitoringMembers",
      "guardduty:TagResource",
      "guardduty:UnarchiveFindings",
      "guardduty:UntagResource",
      "guardduty:UpdateDetector",
      "guardduty:UpdateFilter",
      "guardduty:UpdateFindingsFeedback",
      "guardduty:UpdateIPSet",
      "guardduty:UpdatePublishingDestination",
      "guardduty:UpdateThreatIntelSet"
    ]
    resources = ["*"]
  }

  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_ram.html#example_ram_1
  statement {
    sid       = "PreventingExternalSharing"
    effect    = "Deny"
    actions   = ["ram:CreateResourceShare", "ram:UpdateResourceShare"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "ram:RequestedAllowsExternalPrincipals"
      values   = ["true"]
    }
  }

  statement {
    sid       = "DenyR53ChangesToEnvRecords"
    effect    = "Deny"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "route53:ChangeResourceRecordSetsRecordNames"
      values = [
        "dev.*",
        "tst.*",
        "stg.*"
      ]
    }
    condition {
      test     = "StringNotLikeIfExists"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::*:role/superadmin"
      ]
    }
  }
}

resource "aws_organizations_policy" "workloads_ou" {
  provider = aws.management

  name    = "workloads-ou"
  content = data.aws_iam_policy_document.workloads_ou.json
}

resource "aws_organizations_policy_attachment" "workloads_ou" {
  provider = aws.management

  policy_id = aws_organizations_policy.workloads_ou.id
  target_id = aws_organizations_organizational_unit.workloads.id
}