output "identity_prd" { value = aws_organizations_account.identity_prd.id }

resource "aws_organizations_account" "identity_prd" {
  provider = aws.management

  name  = "${var.account_name_slug.identity}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.identity}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.identity_prd.id
  role_name                  = var.account_role_name
}

# output "identity_stg" { value = aws_organizations_account.identity_stg.id }

# resource "aws_organizations_account" "identity_stg" {
#   provider = aws.management

#   name  = "${var.account_name_slug.identity}-stg"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.identity}-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.identity_stg.id
#   role_name                  = var.account_role_name
# }

# output "identity_tst" { value = aws_organizations_account.identity_tst.id }

# resource "aws_organizations_account" "identity_tst" {
#   provider = aws.management

#   name  = "${var.account_name_slug.identity}-tst"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.identity}-tst@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.identity_tst.id
#   role_name                  = var.account_role_name
# }

# output "identity_dev" { value = aws_organizations_account.identity_dev.id }

# resource "aws_organizations_account" "identity_dev" {
#   provider = aws.management

#   name  = "${var.account_name_slug.identity}-dev"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.identity}-dev@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.identity_dev.id
#   role_name                  = var.account_role_name
# }