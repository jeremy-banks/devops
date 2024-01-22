output "ad_access_url" {
  value =  aws_directory_service_directory.ad_primary.access_url
}

output "ad_security_group_id_primary" {
  value =  aws_directory_service_directory.ad_primary.security_group_id
}

output "ad_security_group_id_failover" {
  value =  data.aws_directory_service_directory.ad_failover.security_group_id
}

output "ad_shared_directory_id" {
  value = { for dir in aws_directory_service_shared_directory.ad_primary : dir.id => dir.shared_directory_id }
}
