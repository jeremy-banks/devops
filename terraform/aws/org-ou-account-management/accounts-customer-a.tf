# resource "aws_organizations_account" "customer_a_prd" {
#   name  = "${local.resource_name_stub}-customer-a-prd"
#   email = "${var.org_owner_email_prefix}-customer_a-prd@${var.org_owner_email_domain_tld}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.customer_a.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "customer_a_prd" {
#   value = aws_organizations_account.customer_a_prd.id
# }

# resource "aws_organizations_account" "customer_a_stg" {
#   name  = "${local.resource_name_stub}-customer-a-stg"
#   email = "${var.org_owner_email_prefix}-customer_a-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.customer_a.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "customer_a_stg" {
#   value = aws_organizations_account.customer_a_stg.id
# }