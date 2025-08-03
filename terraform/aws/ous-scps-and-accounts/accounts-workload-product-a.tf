# resource "aws_organizations_account" "workload_product_a_prd" {
#   name  = var.account_email_slug.workload_product_a_prd
#   email = local.account_owner_email.workload_product_a_prd

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.workloads_prd.id
#   role_name                  = var.account_role_name
# }

# resource "aws_organizations_account" "workload_product_a_stg" {
#   name  = var.account_email_slug.workload_product_a_stg
#   email = local.account_owner_email.workload_product_a_stg

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.workloads_stg.id
#   role_name                  = var.account_role_name
# }

# resource "aws_organizations_account" "workload_product_a_tst" {
#   name  = var.account_email_slug.workload_product_a_tst
#   email = local.account_owner_email.workload_product_a_tst

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.workloads_tst.id
#   role_name                  = var.account_role_name
# }

# resource "aws_organizations_account" "workload_product_a_dev" {
#   name  = var.account_email_slug.workload_product_a_dev
#   email = local.account_owner_email.workload_product_a_dev

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.workloads_dev.id
#   role_name                  = var.account_role_name
# }