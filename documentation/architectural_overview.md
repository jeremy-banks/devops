[Return Home](../README.md#documentation)

# Architectural Overview

## Org and Accounts
<p align="center"><img src="../drawings/org-and-account-layout.drawio.png"/></p>

The organization, organization units, and accounts layout is designed in accordance to the documented [Best practices for a multi-account environment](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html) and [Best practices for managing organizational units (OUs) with AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html). This codebase is can be expanded to accommodate additional OUs such as Sandbox, Suspended, Exceptions, etc.

## VPC Options

### Failover

| Failover Enabled | Failover Disabled |
| :-: | :-: |
| <img src="../drawings/vpc-layout-failover.drawio.png" width="400"/> | <p align="center"><img src="../drawings/vpc-layout.drawio.png" width="400"/> |

The Virtual Private Cloud and Transit Gateway layout is designed in accordance to the Hub and Spoke model in the [Building a Scalable and Secure Multi-VPC AWS Network Infrastructure Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/transit-gateway.html).

- Service Endpoints are shared to the entire Organization through the Network VPCs and Transit Gateways
- Private R53 zone `internal.` is attatched to the Network VPCs providing standard human-readable DNS for the Endpoints
- SDLC Accounts have Network VPC shared to keep cost low

#### Options

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `availability_zones_num_used` | number | 2 | Number of availability zones used in the VPCs for this account, codebase supports 2-6. |
| `network_tgw_share_enabled` | boolean | `false` | Network TGW will be shared to this account. |
| `network_vpc_endpoint_services_enabled` | list(string) | `[""]` | Which endpoint services are attached to the Network VPC and shared through the TGW. |
| `network_vpc_share_enabled` | boolean | `false` | Network VPC will be shared to this account. |
| `vpc_cidr_substitute` | string | `""` | A VPC will be provisioned in the Primary region with the specified CIDR. |
| `vpc_cidr_substitute_failover` | string | `""` | A VPC will be provisioned in the Failover region with the specified CIDR. |

In the Failover Enabled diagram above the following options are defined:

| Account | Options |
| --- | --- |
| Network | `network_vpc_endpoint_services_enabled`, `vpc_cidr_substitute`, `vpc_cidr_substitute_failover` |
| SDLC | `network_vpc_share_enabled` |
| CustomerA | `network_tgw_share_enabled`, `vpc_cidr_substitute`, `vpc_cidr_substitute_failover` |
| CustomerB | `network_tgw_share_enabled`, `vpc_cidr_substitute` |
| CustomerC |  |

In the Failover Disabled diagram above the following options are defined:

| Account | Options |
| --- | --- |
| Network | `network_vpc_endpoint_services_enabled`, `vpc_cidr_substitute` |
| SDLC | `network_vpc_share_enabled` |
| CustomerA | `network_tgw_share_enabled`, `vpc_cidr_substitute` |
| CustomerB | `network_tgw_share_enabled`, `vpc_cidr_substitute` |
| CustomerC |  |
