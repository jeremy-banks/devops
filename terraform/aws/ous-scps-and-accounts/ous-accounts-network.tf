resource "aws_organizations_organizational_unit" "network" {
  provider = aws.management

  name      = var.account_name.network
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_organizational_unit" "network_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.network.id
}

resource "aws_organizations_account" "network_prd" {
  provider = aws.management

  name  = "${var.account_name.network}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.network}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.network_prd.id
  role_name                  = var.account_role_name
}

output "network_prd" { value = aws_organizations_account.network_prd.id }

resource "aws_organizations_organizational_unit" "network_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.network.id
}

resource "aws_organizations_account" "network_stg" {
  provider = aws.management

  name  = "${var.account_name.network}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.network}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.network_stg.id
  role_name                  = var.account_role_name
}

output "network_stg" { value = aws_organizations_account.network_stg.id }