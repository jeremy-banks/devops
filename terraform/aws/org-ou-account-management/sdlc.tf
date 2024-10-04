resource "aws_organizations_account" "sdlc_dev" {
  name  = "${local.resource_name_prefix_abbr}-sdlc-dev"
  email = "${var.org_owner_email_prefix}-sdlc-dev@${var.org_owner_email_domain}"

  close_on_deletion           = true
  create_govcloud             = false
  iam_user_access_to_billing  = "ALLOW"
  parent_id                   = aws_organizations_organizational_unit.workloads.id
  role_name                   = var.assumable_role_name.superadmin
}

output "sdlc_dev" {
  value = aws_organizations_account.sdlc_dev.id
}

# resource "aws_organizations_account" "sdlc_tst" {
#   name  = "${local.resource_name_prefix_abbr}-sdlc-tst"
#   email = "${var.org_owner_email_prefix}-sdlc-tst@${var.org_owner_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "sdlc_tst" {
#   value = aws_organizations_account.sdlc_tst.id
# }

# resource "aws_organizations_account" "sdlc_stg" {
#   name  = "${local.resource_name_prefix_abbr}-sdlc-stg"
#   email = "${var.org_owner_email_prefix}-sdlc-stg@${var.org_owner_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "sdlc_stg" {
#   value = aws_organizations_account.sdlc_stg.id
# }

# resource "aws_organizations_account" "sdlc_prd" {
#   name  = "${local.resource_name_prefix_abbr}-sdlc-prd"
#   email = "${var.org_owner_email_prefix}-sdlc-prd@${var.org_owner_email_domain}"

#   close_on_deletion           = true
#   create_govcloud             = false
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id                   = aws_organizations_organizational_unit.workloads.id
#   role_name                   = var.assumable_role_name.superadmin
# }

# output "sdlc_prd" {
#   value = aws_organizations_account.sdlc_prd.id
# }