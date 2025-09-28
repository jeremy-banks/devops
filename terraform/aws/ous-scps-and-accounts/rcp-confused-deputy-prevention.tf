data "aws_iam_policy_document" "confused_deputy_protection" {
  provider = aws.management

  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_rcps_examples.html#example-rcp-confused-deputy
  statement {
    sid    = "EnforceConfusedDeputyProtection"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*",
      "sqs:*",
      "kms:*",
      "secretsmanager:*",
      "sts:*",
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:SourceOrgID"
      values   = [data.aws_organizations_organization.this.id]
    }
    # condition {
    #   test     = "StringNotEqualsIfExists"
    #   variable = "aws:SourceAccount"
    #   values = local.confused_deputy_protection_allowed_accounts
    # }
    condition {
      test     = "Bool"
      variable = "aws:PrincipalIsAWSService"
      values   = ["true"]
    }
    condition {
      test     = "Null"
      variable = "aws:SourceArn"
      values   = ["false"]
    }
  }
}

resource "aws_organizations_policy" "confused_deputy_protection" {
  provider = aws.management

  name    = "confused-deputy-protection"
  type    = "RESOURCE_CONTROL_POLICY"
  content = data.aws_iam_policy_document.confused_deputy_protection.json
}

resource "aws_organizations_policy_attachment" "confused_deputy_protection" {
  provider = aws.management

  policy_id = aws_organizations_policy.confused_deputy_protection.id
  target_id = aws_organizations_organizational_unit.network.id
}