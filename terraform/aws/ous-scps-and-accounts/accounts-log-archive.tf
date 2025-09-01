output "log_archive_prd" { value = aws_organizations_account.log_archive_prd.id }

resource "aws_organizations_account" "log_archive_prd" {
  provider = aws.management

  name  = "${var.account_name.log_archive}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.log_archive}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.log_archive_prd.id
  role_name                  = var.account_role_name
}

output "log_archive_stg" { value = aws_organizations_account.log_archive_stg.id }

resource "aws_organizations_account" "log_archive_stg" {
  provider = aws.management

  name  = "${var.account_name.log_archive}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.log_archive}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.log_archive_stg.id
  role_name                  = var.account_role_name
}