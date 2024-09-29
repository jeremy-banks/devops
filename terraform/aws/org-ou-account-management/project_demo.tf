resource "aws_organizations_account" "project_demo_nonprod" {
  name  = "${local.resource_name_prefix_abbr}-project-demo-nonprod"
  email = "${var.org_owner_email_prefix}-project-demo-nonprod@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.workloads.id
  role_name                   = var.assumable_role_name.superadmin
}

output "project_demo_nonprod" {
  value = aws_organizations_account.project_demo_nonprod.id
}

resource "aws_organizations_account" "project_demo_prod" {
  name  = "${local.resource_name_prefix_abbr}-project-demo-prod"
  email = "${var.org_owner_email_prefix}-project-demo-prod@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.workloads.id
  role_name                   = var.assumable_role_name.superadmin
}

output "project_demo_prod" {
  value = aws_organizations_account.project_demo_prod.id
}