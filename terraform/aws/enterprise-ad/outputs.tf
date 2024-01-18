output "ad_access_url" {
  value =  aws_directory_service_directory.ad_primary.access_url
}

output "foo" {
  value =  aws_directory_service_region.ad_failover.id
}