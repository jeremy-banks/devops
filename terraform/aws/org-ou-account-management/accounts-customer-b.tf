# resource "aws_organizations_account" "customer_b_prd" {
#   name  = "${local.resource_name_stub}-customer-b-prd"
#   email = "${var.org_owner_email_prefix}-customer_b-prd@${var.org_owner_email_domain_tld}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.customer_b.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "customer_b_prd" {
#   value = aws_organizations_account.customer_b_prd.id
# }

# resource "aws_organizations_account" "customer_b_stg" {
#   name  = "${local.resource_name_stub}-customer-b-stg"
#   email = "${var.org_owner_email_prefix}-customer_b-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.customer_b.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "customer_b_stg" {
#   value = aws_organizations_account.customer_b_stg.id
# }