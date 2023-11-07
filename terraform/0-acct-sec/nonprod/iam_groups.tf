# admin
# unrestricted access to the account
resource "aws_iam_group" "admin" {
  name = "admin"
}

resource "aws_iam_group_policy_attachment" "admin_allow_all" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



# devops
# mostly unrestricted access to the account
resource "aws_iam_group" "devops" {
  name = "devops"
}

resource "aws_iam_group_policy_attachment" "devops_allow_all" {
  group      = aws_iam_group.devops.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "devops_allow_self_manage_creds_and_mfa_policy" {
  group      = aws_iam_group.devops.name
  policy_arn = aws_iam_policy.allow_self_manage_creds_and_mfa.arn
}



# ops
# readonly with some additional rights eg terminating eks nodes
resource "aws_iam_group" "ops" {
  name = "ops"
}

resource "aws_iam_group_policy_attachment" "ops_allow_readonly" {
  group      = aws_iam_group.ops.name
  policy_arn = aws_iam_policy.allow_readonly.arn
}

resource "aws_iam_group_policy_attachment" "ops_allow_self_manage_creds_and_mfa_policy" {
  group      = aws_iam_group.ops.name
  policy_arn = aws_iam_policy.allow_self_manage_creds_and_mfa.arn
}

resource "aws_iam_group_policy_attachment" "ops_deny_edits_to_tagged_infra_policy" {
  group      = aws_iam_group.ops.name
  policy_arn = aws_iam_policy.deny_edits_to_tagged_infra.arn
}

resource "aws_iam_group_policy_attachment" "ops_deny_unused_regions_policy" {
  group      = aws_iam_group.ops.name
  policy_arn = aws_iam_policy.deny_edits_to_tagged_infra.arn
}



# dev
# readonly with some additional rights eg restoring databases in nonprod
resource "aws_iam_group" "dev" {
  name = "dev"
}

resource "aws_iam_group_policy_attachment" "dev_allow_readonly" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.allow_readonly.arn
}

resource "aws_iam_group_policy_attachment" "dev_allow_self_manage_creds_and_mfa_policy" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.allow_self_manage_creds_and_mfa.arn
}

resource "aws_iam_group_policy_attachment" "dev_deny_edits_to_tagged_infra_policy" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.deny_edits_to_tagged_infra.arn
}

resource "aws_iam_group_policy_attachment" "dev_deny_unused_regions_policy" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.deny_edits_to_tagged_infra.arn
}



# qa
resource "aws_iam_group" "qa" {
  name = "qa"
}

resource "aws_iam_group_policy_attachment" "qa_allow_readonly" {
  group      = aws_iam_group.qa.name
  policy_arn = aws_iam_policy.allow_readonly.arn
}

resource "aws_iam_group_policy_attachment" "qa_allow_self_manage_creds_and_mfa_policy" {
  group      = aws_iam_group.qa.name
  policy_arn = aws_iam_policy.allow_self_manage_creds_and_mfa.arn
}

resource "aws_iam_group_policy_attachment" "qa_deny_edits_to_tagged_infra_policy" {
  group      = aws_iam_group.qa.name
  policy_arn = aws_iam_policy.deny_edits_to_tagged_infra.arn
}

resource "aws_iam_group_policy_attachment" "qa_deny_unused_regions_policy" {
  group      = aws_iam_group.qa.name
  policy_arn = aws_iam_policy.deny_edits_to_tagged_infra.arn
}



# billing
resource "aws_iam_group" "billing" {
  name = "billing"
}

resource "aws_iam_group_policy_attachment" "billing_allow_billing" {
  group      = aws_iam_group.billing.name
  policy_arn = aws_iam_policy.allow_billing.arn
}

resource "aws_iam_group_policy_attachment" "billing_allow_self_manage_creds_and_mfa_policy" {
  group      = aws_iam_group.billing.name
  policy_arn = aws_iam_policy.allow_self_manage_creds_and_mfa.arn
}