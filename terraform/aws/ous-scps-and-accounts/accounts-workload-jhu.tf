output "workload_jhu_prd" { value = aws_organizations_account.workload_jhu_prd.id }

resource "aws_organizations_account" "workload_jhu_prd" {
  provider = aws.management

  name  = "${var.account_name.workload_jhu}-prd"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_jhu}-prd@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_jhu_prd.id
  role_name                  = var.account_role_name
}

output "workload_jhu_stg" { value = aws_organizations_account.workload_jhu_stg.id }

resource "aws_organizations_account" "workload_jhu_stg" {
  provider = aws.management

  name  = "${var.account_name.workload_jhu}-stg"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_jhu}-stg@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_jhu_stg.id
  role_name                  = var.account_role_name
}

output "workload_jhu_tst" { value = aws_organizations_account.workload_jhu_tst.id }

resource "aws_organizations_account" "workload_jhu_tst" {
  provider = aws.management

  name  = "${var.account_name.workload_jhu}-tst"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_jhu}-tst@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_jhu_tst.id
  role_name                  = var.account_role_name
}

output "workload_jhu_dev" { value = aws_organizations_account.workload_jhu_dev.id }

resource "aws_organizations_account" "workload_jhu_dev" {
  provider = aws.management

  name  = "${var.account_name.workload_jhu}-dev"
  email = "${var.org_owner_email_prefix}+${var.org_owner_email_plus_address}-${var.account_name.workload_jhu}-dev@${var.org_owner_email_domain_tld}"

  close_on_deletion          = true
  create_govcloud            = false
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workload_jhu_dev.id
  role_name                  = var.account_role_name
}