data "aws_iam_policy_document" "org_1" {
  provider = aws.management

  # deny account changes
  statement {
    effect = "Deny"
    actions = [
      "account:AcceptPrimaryEmailUpdate",
      "account:CloseAccount",
      "account:DeleteAlternateContact",
      "account:DisableRegion",
      "account:EnableRegion",
      "account:Put*",
      "account:StartPrimaryEmailUpdate",
    ]
    resources = ["*"]
    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:root",
      ]
    }
  }

  # deny unused regions
  # https://docs.aws.amazon.com/controltower/latest/controlreference/primary-region-deny-policy.html
  statement {
    effect = "Deny"
    not_actions = [
      "a4b:*",
      "acm:*",
      "aws-marketplace-management:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "config:*",
      "cur:*",
      "directconnect:*",
      "ec2:DescribeRegions",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpnGateways",
      "fms:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "kms:*",
      "mobileanalytics:*",
      "networkmanager:*",
      "organizations:*",
      "pricing:*",
      "route53-recovery-cluster:*",
      "route53-recovery-control-config:*",
      "route53-recovery-readiness:*",
      "route53:*",
      "route53domains:*",
      "s3:GetAccountPublic*",
      "s3:ListAllMyBuckets",
      "s3:ListMultiRegionAccessPoints",
      "s3:PutAccountPublic*",
      "shield:*",
      "sts:*",
      "support:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wafv2:*",
      "wellarchitected:*"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = [var.region_primary.full, var.region_failover.full]
    }
    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/AWSControlTowerExecution",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:root",
      ]
    }
  }

  # deny iam
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html#example-scp-restricts-iam-principals
  statement {
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
      values = [
        "$${aws:ResourceArn}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:root",
      ]
    }
    condition {
      test     = "StringNotLikeIfExists"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/eksctl-*"
      ]
    }
  }

  # deny accounts leaving org
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html#example-scp-leave-org
  statement {
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }

  # deny cloudwatch changes
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_cloudwatch.html
  statement {
    effect = "Deny"
    actions = [
      "cloudwatch:Delete*",
      "cloudwatch:Disable*",
      "cloudwatch:Put*",
      "cloudwatch:SetAlarmState",
    ]
    resources = ["*"]
    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:root",
      ]
    }
  }

  # deny config changes
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_config.html
  statement {
    effect    = "Deny"
    actions   = ["config:*"]
    resources = ["*"]
    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:role/${var.account_role_name}",
        "arn:aws:iam::${"$${aws:PrincipalAccount}"}:root",
      ]
    }
  }

  # deny disable ebs encryption
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_ec2.html#example-ec2-3
  statement {
    effect    = "Deny"
    actions   = ["ec2:DisableEbsEncryptionByDefault"]
    resources = ["*"]
  }

  # deny non gp3 volumes
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_ec2.html#example-ec2-4
  statement {
    effect = "Deny"
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateVolume",
      "ec2:RunInstances"
    ]
    resources = ["arn:aws:ec2:*:*:volume/*"]
    condition {
      test     = "StringNotEquals"
      variable = "ec2:VolumeType"
      values   = ["gp3"]
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