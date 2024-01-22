output "ad_access_url" {
  value =  aws_directory_service_directory.ad_primary.access_url
}

output "ad_security_group_id_primary" {
  value =  aws_directory_service_directory.ad_primary.security_group_id
}

# output "ad_security_group_id_failover" {
#   value =  data.aws_directory_service_directory.ad_failover.security_group_id
# }