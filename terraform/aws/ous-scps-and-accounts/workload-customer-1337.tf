# resource "aws_organizations_organizational_unit" "customer_1337" {
#   name      = "customer_1337"
#   parent_id = aws_organizations_organizational_unit.workloads.id
# }

# resource "aws_organizations_organizational_unit" "customer_1337_nonprod" {
#   name      = "nonprod"
#   parent_id = aws_organizations_organizational_unit.customer_1337.id
# }

# resource "aws_organizations_organizational_unit" "customer_1337_prod" {
#   name      = "prod"
#   parent_id = aws_organizations_organizational_unit.customer_1337.id
# }

# resource "aws_organizations_account" "customer_1337_prd" {
#   name  = "${local.resource_name_stub}-customer-1337-prd"
#   email = "${var.org_owner_email_prefix}-customer-1337-prd@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.customer_1337_prod.id
#   role_name                  = var.assumable_role_name.superadmin
# }

# output "customer_1337_prd" {
#   value = aws_organizations_account.customer_1337_prd.id
# }

# resource "aws_organizations_account" "customer_1337_stg" {
#   name  = "${local.resource_name_stub}-customer-1337-stg"
#   email = "${var.org_owner_email_prefix}-customer-1337-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.customer_1337_nonprod.id
#   role_name                  = var.assumable_role_name.superadmin
# }

# output "customer_1337_stg" {
#   value = aws_organizations_account.customer_1337_stg.id
# }

# resource "aws_organizations_account" "customer_1337_tst" {
#   name  = "${local.resource_name_stub}-customer-1337-tst"
#   email = "${var.org_owner_email_prefix}-customer-1337-tst@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.customer_1337_nonprod.id
#   role_name                  = var.assumable_role_name.superadmin
# }

# output "customer_1337_tst" {
#   value = aws_organizations_account.customer_1337_tst.id
# }

# resource "aws_organizations_account" "customer_1337_dev" {
#   name  = "${local.resource_name_stub}-customer-1337-dev"
#   email = "${var.org_owner_email_prefix}-customer-1337-dev@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.customer_1337_nonprod.id
#   role_name                  = var.assumable_role_name.superadmin
# }

# output "customer_1337_dev" {
#   value = aws_organizations_account.customer_1337_dev.id
# }