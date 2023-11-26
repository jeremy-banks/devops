module "project1_dns_logs_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  providers = { aws = aws.log-archive }

  aliases = ["foo"]
  multi_region = true
  deletion_window_in_days = 30
}



module "project1_dns_logs_kms_replica" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.1.0"

  providers = { aws = aws.log-archive-dr }

  aliases = ["foo_replica"]
  create_replica = true
  primary_key_arn = module.project1_dns_logs_kms.key_arn
  deletion_window_in_days = 30
  enable_key_rotation = true

}

