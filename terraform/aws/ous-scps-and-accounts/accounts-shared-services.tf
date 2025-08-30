output "shared_services_prd" { value = aws_organizations_account.shared_services_prd.id }

resource "aws_organizations_account" "shared_services_prd" {
  provider = aws.management

  name  = "${var.account_name_slug.shared_services}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.shared_services}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.shared_services_prd.id
  role_name                  = var.account_role_name
}

# output "shared_services_stg" { value = aws_organizations_account.shared_services_stg.id }

# resource "aws_organizations_account" "shared_services_stg" {
#   provider = aws.management

#   name  = "${var.account_name_slug.shared_services}-stg"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.shared_services}-stg@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.shared_services_stg.id
#   role_name                  = var.account_role_name
# }

# output "shared_services_tst" { value = aws_organizations_account.shared_services_tst.id }

# resource "aws_organizations_account" "shared_services_tst" {
#   provider = aws.management

#   name  = "${var.account_name_slug.shared_services}-tst"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.shared_services}-tst@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.shared_services_tst.id
#   role_name                  = var.account_role_name
# }

# output "shared_services_dev" { value = aws_organizations_account.shared_services_dev.id }

# resource "aws_organizations_account" "shared_services_dev" {
#   provider = aws.management

#   name  = "${var.account_name_slug.shared_services}-dev"
#   email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name_slug.shared_services}-dev@${var.org_owner_email_domain_tld}"

#   close_on_deletion          = true
#   create_govcloud            = false
#   iam_user_access_to_billing = "ALLOW"
#   parent_id                  = aws_organizations_organizational_unit.shared_services_dev.id
#   role_name                  = var.account_role_name
# }