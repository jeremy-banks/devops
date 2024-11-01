data "aws_iam_policy_document" "deny_region_interaction" {
  statement {
    sid       = "DenyRegionInteraction"
    actions   = ["account:EnableRegion", "account:DisableRegion"]
    resources = ["*"]
    effect    = "Deny"
  }
}

resource "aws_organizations_policy" "deny_region_interaction" {
  name        = "deny-region-interaction"
  description = "Deny the ability to enable or disable a region"
  content     = data.aws_iam_policy_document.deny_region_interaction.json
}

data "aws_iam_policy_document" "deny_restricted_regions" {
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html
  statement {
    sid         = "DenyRestrictedRegions"
    effect      = "Deny"
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
    resources   = ["*"]
    condition {
      test      = "StringNotEquals"
      variable  = "aws:RequestedRegion"
      values    = [var.region.primary, var.region.failover]
    }
  }
}

resource "aws_organizations_policy" "deny_restricted_regions" {
  name        = "deny-restricted-regions"
  description = "Deny the use of restricted regions"
  content     = data.aws_iam_policy_document.deny_restricted_regions.json
}