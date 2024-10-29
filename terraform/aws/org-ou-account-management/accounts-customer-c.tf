# resource "aws_organizations_account" "customer_c_prd" {
#   name  = "${local.resource_name_stub}-customer-c-prd"
#   email = "${var.org_owner_email_prefix}-customer_c-prd@${var.org_owner_email_domain_tld}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.customer_c.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "customer_c_prd" {
#   value = aws_organizations_account.customer_c_prd.id
# }

# resource "aws_organizations_account" "customer_c_stg" {
#   name  = "${local.resource_name_stub}-customer-c-stg"
#   email = "${var.org_owner_email_prefix}-customer_c-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.customer_c.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "customer_c_stg" {
#   value = aws_organizations_account.customer_c_stg.id
# }