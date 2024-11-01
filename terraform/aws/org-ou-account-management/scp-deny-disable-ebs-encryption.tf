data "aws_iam_policy_document" "deny_disable_ebs_encryption" {
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_ec2.html#example-ec2-3
  statement {
    sid       = "PreventDisablingOfDefaultAmazonEBSEncryption"
    effect    = "Deny"
    actions   = ["ec2:DisableEbsEncryptionByDefault"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_disable_ebs_encryption" {
  name        = "deny-disable-ebs-encryption"
  description = "Prevent disabling of default Amazon EBS encryption"
  content     = data.aws_iam_policy_document.deny_disable_ebs_encryption.json
}