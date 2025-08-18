resource "aws_organizations_organizational_unit" "log_archive" {
  name      = var.account_name_slug.log_archive
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_organizational_unit" "log_archive_prd" {
  name      = "prd"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}

resource "aws_organizations_organizational_unit" "log_archive_stg" {
  name      = "stg"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}

resource "aws_organizations_organizational_unit" "log_archive_tst" {
  name      = "tst"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}

resource "aws_organizations_organizational_unit" "log_archive_dev" {
  name      = "dev"
  parent_id = aws_organizations_organizational_unit.log_archive.id
}