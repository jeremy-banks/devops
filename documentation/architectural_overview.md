[Return Home](../README.md#documentation)

# Architectural Overview

## Org and Accounts
The organization, organization units, and accounts layout is designed in accordance to the documented [Best practices for a multi-account environment](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html) and [Best practices for managing organizational units (OUs) with AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html). Specifically, the [Separating business units with significantly different policies](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/advanced-ous.html#extended-workload-oriented-ou-structure) is utilized for maximum security granularity and scaleability.

<p align="center"><img src="../drawings/org-and-account-layout.drawio.png"/></p>

This codebase is can be expanded to accommodate additional OUs such as Sandbox, Suspended, Exceptions, etc.

## VPC Central Inspection Model

This repo follows the documented guide for North-South Inspection with AWS Network Firewall as [documented by AWS](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/inspection-deployment-models-with-AWS-network-firewall-ra.pdf). Behold, the Central Inspection Cephalopod (resemblence unintended):

<p align="center"><img src="../drawings/central-inspection.drawio.png"/></p>

1. Public Ingress to Inspection to Workload
1. Client VPN / Direct Connect / Site-to-Site VPN to Inspection to Workload (bi-directional)
1. Workload to Inspection to Service Endpoint
1. Workload to Inspection to Internet
1. Workload to Inspection to VPC Peer / NAT / VPN (bi-directional)

Because everything deployed is a "workload", including even the Shared Services and SDLC accounts, this setup enables maximum scalability and cost savings. Each additional account benefits from the same Central Inspection model, Logging, Central Service Endpoints, and Central Egress to Internet, without any additional configuration requirements.