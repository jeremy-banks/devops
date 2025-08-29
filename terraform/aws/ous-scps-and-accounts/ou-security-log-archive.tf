resource "aws_organizations_organizational_unit" "log_archive" {
  provider = aws.management

  name      = var.account_name_slug.log_archive
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_organizational_unit" "log_archive_prd" {
  provider = aws.management

  name      = "prd"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}

resource "aws_organizations_organizational_unit" "log_archive_stg" {
  provider = aws.management

  name      = "stg"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}

resource "aws_organizations_organizational_unit" "log_archive_tst" {
  provider = aws.management

  name      = "tst"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}

resource "aws_organizations_organizational_unit" "log_archive_dev" {
  provider = aws.management

  name      = "dev"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}