resource "aws_organizations_organizational_unit" "workload_wsu" {
  provider = aws.management

  name      = var.account_name.workload_wsu
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workload_wsu_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.workload_wsu.id
}

resource "aws_organizations_account" "workload_wsu_prd" {
  provider = aws.management

  name  = "${var.account_name.workload_wsu}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.workload_wsu}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_wsu_prd.id
  role_name                  = var.account_role_name
}

output "workload_wsu_prd" { value = aws_organizations_account.workload_wsu_prd.id }

resource "aws_organizations_organizational_unit" "workload_wsu_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.workload_wsu.id
}

resource "aws_organizations_account" "workload_wsu_stg" {
  provider = aws.management

  name  = "${var.account_name.workload_wsu}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.workload_wsu}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_wsu_stg.id
  role_name                  = var.account_role_name
}

output "workload_wsu_stg" { value = aws_organizations_account.workload_wsu_stg.id }

resource "aws_organizations_organizational_unit" "workload_wsu_tst" {
  provider = aws.management

  name      = "tst"
  parent_id = aws_organizations_organizational_unit.workload_wsu.id
}

resource "aws_organizations_account" "workload_wsu_tst" {
  provider = aws.management

  name  = "${var.account_name.workload_wsu}-tst"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.workload_wsu}-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_wsu_tst.id
  role_name                  = var.account_role_name
}

output "workload_wsu_tst" { value = aws_organizations_account.workload_wsu_tst.id }

resource "aws_organizations_organizational_unit" "workload_wsu_dev" {
  provider = aws.management

  name      = "dev"
  parent_id = aws_organizations_organizational_unit.workload_wsu.id
}

resource "aws_organizations_account" "workload_wsu_dev" {
  provider = aws.management

  name  = "${var.account_name.workload_wsu}-dev"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.email_suffix.workload_wsu}-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_wsu_dev.id
  role_name                  = var.account_role_name
}

output "workload_wsu_dev" { value = aws_organizations_account.workload_wsu_dev.id }