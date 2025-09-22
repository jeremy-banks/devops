resource "aws_organizations_organizational_unit" "shared_services" {
  provider = aws.management

  name      = var.account_name.shared_services
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "shared_services_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}

resource "aws_organizations_account" "shared_services_prd" {
  provider = aws.management

  name  = "${var.account_name.shared_services}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.shared_services}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.shared_services_prd.id
  role_name                  = var.account_role_name
}

output "shared_services_prd" { value = aws_organizations_account.shared_services_prd.id }

resource "aws_organizations_organizational_unit" "shared_services_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.shared_services.id
}

resource "aws_organizations_account" "shared_services_stg" {
  provider = aws.management

  name  = "${var.account_name.shared_services}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.shared_services}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.shared_services_stg.id
  role_name                  = var.account_role_name
}

output "shared_services_stg" { value = aws_organizations_account.shared_services_stg.id }