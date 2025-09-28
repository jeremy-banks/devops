#ad connector
resource "aws_directory_service_directory" "connector_network" {
  provider = aws.network

  name     = "corp.${var.company_domain}"
  password = var.ad_directory_admin_password
  size     = "Small"
  type     = "ADConnector"

  connect_settings {
    customer_dns_ips  = aws_directory_service_directory.ad_primary.dns_ip_addresses
    customer_username = "Admin"
    vpc_id            = data.aws_vpc.network_primary.id
    subnet_ids        = slice(data.aws_subnets.network_primary.ids, 0, 2)
  }
}

output "ad_directory_id_connector_network" {
  value = aws_directory_service_directory.connector_network.id
}

resource "aws_directory_service_directory" "connector_network_failover" {
  provider = aws.network_failover

  name     = "corp.${var.company_domain}"
  password = var.ad_directory_admin_password
  size     = "Small"
  type     = "ADConnector"

  connect_settings {
    customer_dns_ips  = data.aws_directory_service_directory.ad_failover.dns_ip_addresses
    customer_username = "Admin"
    vpc_id            = data.aws_vpc.network_failover.id
    subnet_ids        = slice(data.aws_subnets.network_failover.ids, 0, 2)
  }
}

output "ad_directory_id_connector_network_failover" {
  value = aws_directory_service_directory.connector_network_failover.id
}