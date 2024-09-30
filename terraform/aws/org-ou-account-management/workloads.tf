resource "aws_organizations_account" "workload_dev" {
  name  = "${local.resource_name_prefix_abbr}-workload-dev"
  email = "${var.org_owner_email_prefix}-workload-dev@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.workloads.id
  role_name                   = var.assumable_role_name.superadmin
}

output "workload_dev" {
  value = aws_organizations_account.workload_dev.id
}

# resource "aws_organizations_account" "workload_tst" {
#   name  = "${local.resource_name_prefix_abbr}-workload-tst"
#   email = "${var.org_owner_email_prefix}-workload-tst@${var.org_owner_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "workload_tst" {
#   value = aws_organizations_account.workload_tst.id
# }

# resource "aws_organizations_account" "workload_stg" {
#   name  = "${local.resource_name_prefix_abbr}-workload-stg"
#   email = "${var.org_owner_email_prefix}-workload-stg@${var.org_owner_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "workload_stg" {
#   value = aws_organizations_account.workload_stg.id
# }

# resource "aws_organizations_account" "workload_prd" {
#   name  = "${local.resource_name_prefix_abbr}-workload-prd"
#   email = "${var.org_owner_email_prefix}-workload-prd@${var.org_owner_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "workload_prd" {
#   value = aws_organizations_account.workload_prd.id
# }