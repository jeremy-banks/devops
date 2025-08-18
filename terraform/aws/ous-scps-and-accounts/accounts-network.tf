resource "aws_organizations_account" "network_prd" {
  name  = "${var.account_name_slug.network}-prd"
  email = "${var.org_owner_email_prefix}-${var.account_name_slug.network}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.network_prd.id
  role_name                  = var.account_role_name
}

# resource "aws_organizations_account" "network_stg" {
#   name  = "${var.account_name_slug.network}-stg"
#   email = "${var.org_owner_email_prefix}-${var.account_name_slug.network}-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.network_stg.id
#   role_name                  = var.account_role_name
# }

# resource "aws_organizations_account" "network_tst" {
#   name  = "${var.account_name_slug.network}-tst"
#   email = "${var.org_owner_email_prefix}-${var.account_name_slug.network}-tst@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.network_tst.id
#   role_name                  = var.account_role_name
# }

# resource "aws_organizations_account" "network_dev" {
#   name  = "${var.account_name_slug.network}-dev"
#   email = "${var.org_owner_email_prefix}-${var.account_name_slug.network}-dev@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.network_dev.id
#   role_name                  = var.account_role_name
# }