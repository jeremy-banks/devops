data "aws_iam_policy_document" "deny_disable_config" {
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_config.html#example_config_1
  statement {
    sid       = "PreventUsersFromDisablingAWSConfigOrChangingItsRules"
    effect    = "Deny"
    actions   = [
      "config:DeleteConfigRule",
      "config:DeleteConfigurationRecorder",
      "config:DeleteDeliveryChannel",
      "config:StopConfigurationRecorder",
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_disable_config" {
  name        = "deny-disable-config"
  description = "Prevent users from disabling AWS Config or changing its rules"
  content     = data.aws_iam_policy_document.deny_disable_config.json
}