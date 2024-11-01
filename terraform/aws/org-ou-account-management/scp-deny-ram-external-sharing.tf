data "aws_iam_policy_document" "deny_external_sharing" {
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_ram.html#example_ram_1
  statement {
    sid       = "PreventingExternalSharing"
    effect    = "Deny"
    actions   = ["ram:CreateResourceShare", "ram:UpdateResourceShare"]
    resources = ["*"]
    condition {
      test      = "Bool"
      variable  = "ram:RequestedAllowsExternalPrincipals"
      values    = ["true"]
    }
  }
}

resource "aws_organizations_policy" "deny_external_sharing" {
  name        = "deny-external-sharing"
  description = "Preventing External Sharing"
  content     = data.aws_iam_policy_document.deny_external_sharing.json
}