# resource "aws_organizations_account" "workload_product_a_prd" {
#   name  = var.account_email_slug.workload_product_a_prd
#   email = local.account_owner_email.workload_product_a_prd

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.workloads_prd.id
#   role_name                  = var.account_role_name
# }