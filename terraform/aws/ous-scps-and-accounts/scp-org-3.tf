data "aws_iam_policy_document" "org_3" {
  provider = aws.management

  # prevent adding internet access to VPC
  # https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_vpc.html#example_vpc_2
  statement {
    effect = "Deny"
    actions = [
      "ec2:AttachInternetGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateEgressOnlyInternetGateway",
      "ec2:CreateVpcPeeringConnection",
      "ec2:AcceptVpcPeeringConnection",
      "globalaccelerator:Create*",
      "globalaccelerator:Update*"
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
}

resource "aws_organizations_policy" "org_3" {
  provider = aws.management

  name    = "org-3"
  content = data.aws_iam_policy_document.org_3.json
}

resource "aws_organizations_policy_attachment" "org_3" {
  provider = aws.management

  policy_id = aws_organizations_policy.org_3.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}