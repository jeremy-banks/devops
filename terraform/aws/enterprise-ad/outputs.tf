output "ad_access_url" {
  value =  aws_directory_service_directory.ad_primary.access_url
}

output "ad_security_group_id_primary" {
  value =  aws_directory_service_directory.ad_primary.security_group_id
}

output "ad_security_group_id_failover" {
  value =  data.aws_directory_service_directory.ad_failover.security_group_id
}

output "ad_directory_id" {
  value = aws_directory_service_directory.ad_primary.id
}

# output "foo" {
#   value = [for k in keys(aws_directory_service_shared_directory.ad_primary) : element(split("/", k), 1)] #gives account numbers
# }

# output "bar" {
#   value = values(aws_directory_service_shared_directory.ad_primary)[*].shared_directory_id #gives directory numbers
# }

output "ad_account_id_shared_directory_map" {
  value = { 
    for idx, key in keys(aws_directory_service_shared_directory.ad_primary) : 
      element(split("/", key), 1) => 
      values(aws_directory_service_shared_directory.ad_primary)[idx].shared_directory_id 
  }
}