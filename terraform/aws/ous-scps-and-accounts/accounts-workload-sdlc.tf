output "workload_sdlc_prd" { value = aws_organizations_account.workload_sdlc_prd.id }

resource "aws_organizations_account" "workload_sdlc_prd" {
  provider = aws.management

  name  = "${var.account_name.workload_sdlc}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_sdlc}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_sdlc_prd.id
  role_name                  = var.account_role_name
}

output "workload_sdlc_stg" { value = aws_organizations_account.workload_sdlc_stg.id }

resource "aws_organizations_account" "workload_sdlc_stg" {
  provider = aws.management

  name  = "${var.account_name.workload_sdlc}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_sdlc}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_sdlc_stg.id
  role_name                  = var.account_role_name
}

output "workload_sdlc_tst" { value = aws_organizations_account.workload_sdlc_tst.id }

resource "aws_organizations_account" "workload_sdlc_tst" {
  provider = aws.management

  name  = "${var.account_name.workload_sdlc}-tst"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_sdlc}-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_sdlc_tst.id
  role_name                  = var.account_role_name
}

output "workload_sdlc_dev" { value = aws_organizations_account.workload_sdlc_dev.id }

resource "aws_organizations_account" "workload_sdlc_dev" {
  provider = aws.management

  name  = "${var.account_name.workload_sdlc}-dev"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_sdlc}-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_sdlc_dev.id
  role_name                  = var.account_role_name
}