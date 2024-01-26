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
    vpc_id     = data.aws_vpc.shared_primary.id
    subnet_ids = [data.aws_subnet.shared_a_primary.id, data.aws_subnet.shared_b_primary.id]
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
    vpc_id     = data.aws_vpc.shared_failover.id
    subnet_ids = [data.aws_subnet.shared_a_failover.id, data.aws_subnet.shared_b_failover.id]
  }
}

output "ad_directory_id_connector_network_failover" {
  value = aws_directory_service_directory.connector_network_failover.id
}