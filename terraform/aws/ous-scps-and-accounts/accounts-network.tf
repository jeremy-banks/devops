output "network_prd" { value = aws_organizations_account.network_prd.id }

resource "aws_organizations_account" "network_prd" {
  provider = aws.management

  name  = "${var.account_name_slug.network}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.network}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.network_prd.id
  role_name                  = var.account_role_name
}

# output "network_stg" { value = aws_organizations_account.network_stg.id }

# resource "aws_organizations_account" "network_stg" {
#   provider = aws.management

#   name  = "${var.account_name_slug.network}-stg"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.network}-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.network_stg.id
#   role_name                  = var.account_role_name
# }

# output "network_tst" { value = aws_organizations_account.network_tst.id }

# resource "aws_organizations_account" "network_tst" {
#   provider = aws.management

#   name  = "${var.account_name_slug.network}-tst"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.network}-tst@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.network_tst.id
#   role_name                  = var.account_role_name
# }

# output "network_dev" { value = aws_organizations_account.network_dev.id }

# resource "aws_organizations_account" "network_dev" {
#   provider = aws.management

#   name  = "${var.account_name_slug.network}-dev"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.network}-dev@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.network_dev.id
#   role_name                  = var.account_role_name
# }