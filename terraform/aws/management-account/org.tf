resource "aws_organizations_organization" "this" {
  aws_service_access_principals = var.org_service_access_principals
  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "BACKUP_POLICY",
    "CHATBOT_POLICY",
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]
  feature_set = "ALL"
}