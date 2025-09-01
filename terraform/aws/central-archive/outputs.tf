output "central_archive_bucket_primary" { value = module.s3_primary.s3_bucket_id }
output "central_archive_bucket_failover" { value = module.s3_failover[0].s3_bucket_id }