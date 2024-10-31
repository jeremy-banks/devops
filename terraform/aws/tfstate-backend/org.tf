resource "aws_organizations_organization" "this" {
  provider = aws.org

  aws_service_access_principals = var.org_aws_service_access_principals
  feature_set = "ALL"
}