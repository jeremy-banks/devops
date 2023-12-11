# resource "aws_organizations_account" "project1_nonprod" {
#   name  = "${local.resource_name_stub}-project1-nonprod"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-project1-nonprod@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "project1_nonprod_account_id" {
#   value = aws_organizations_account.project1_nonprod.id
# }

# resource "aws_organizations_account" "project1_prod" {
#   name  = "${local.resource_name_stub}-project1-prod"
#   email = "${var.company_email_prefix}+${local.resource_name_stub}-project1-prod@${var.company_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "project1_prod_account_id" {
#   value = aws_organizations_account.project1_prod.id
# }