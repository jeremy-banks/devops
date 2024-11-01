data "aws_iam_policy_document" "deny_accounts_leaving_org" {
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html#example-scp-leave-org
  statement {
    sid       = "PreventMemberAccountsFromLeavingTheOrganization"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
    effect    = "Deny"
  }
}

resource "aws_organizations_policy" "deny_accounts_leaving_org" {
  name        = "deny-accounts-leaving-org"
  description = "Prevent member accounts from leaving the organization"
  content     = data.aws_iam_policy_document.deny_accounts_leaving_org.json
}