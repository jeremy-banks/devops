# users
data "aws_iam_policy_document" "iam_user_automation" {
  statement {
    sid = "AllowAssumeRoleAutomationInOrg"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${var.assumable_role_name.automation}"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values = [data.aws_organizations_organization.this.id]
    }
  }
}

module "iam_user_automation_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.45.0"
  providers = { aws = aws.org }

  name = "automation"

  policy = data.aws_iam_policy_document.iam_user_automation.json
}

module "iam_user_automation" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.45.0"
  providers = { aws = aws.org }

  name = var.assumable_role_name.automation

  create_iam_user_login_profile = false
  create_iam_access_key         = true
  policy_arns                   = [
    module.iam_user_automation_policy.arn,
    "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess",
  ]
}
