# DevOps
Thank you for visiting my repo, and please consider leaving a Star!

The goal of this repo is to provide a comprehensive codebase to lift-and-shift any organinzation into the ideal AWS and EKS deployment using official documented best practices, prescriptive guidance, and white papers.

## My Education and Certifications
[![Bachelor's: Genetics and Cell Biology - Washington State University](https://img.shields.io/badge/Bachelor's-Genetics_and_Cell_Biology_--_WSU_(PURSUING)-rgb(152,36,49)?style=plastic)](https://degrees.wsu.edu/degree/genetics-cell-biology/)<br>
[![Terraform Associate](https://img.shields.io/badge/Certificate-HashiCorp_Certified:_Terraform_Associate-rgb(115,73,182)?style=plastic)](https://www.credly.com/badges/736aae79-b1fd-4567-a3d2-d1e1a27ff182)<br>
[![Unity Prototyping UW](https://img.shields.io/badge/Certificate-Specialization_in_Game_Prototyping_with_Unity-rgb(255,255,255)?style=plastic)](https://badgr.com/public/assertions/HtqMeP7NSSaEzOeMzOowCA)

<!-- ## Documentation
- [Initial Setup](./documentation/initial_setup.md)
- [Processes](./documentation/processes.md) -->

## Reference Material
- [Whitepaper: Genomics Data Transfer, Analytics, and Machine Learning using AWS Services](https://aws.amazon.com/blogs/industries/whitepaper-genomics-data-transfer-analytics-and-machine-learning-using-aws-services/)
- [Prescriptive Guidance Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html)
- [Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [Best practices for a multi-account environment](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html)
- [Best practices for OUs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html)
- [Inspection Deployment Models with AWS Network Firewall](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/inspection-deployment-models-with-AWS-network-firewall-ra.pdf)
- [Centralized Inspection Architecture](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-central-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)
- [Transit Gateway Design Best Practices](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-best-design-practices.html)
- [How Transit Gateways Work in Appliance Mode](https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html#transit-gateway-appliance-scenario)
- [Automating Domain Delegation for Public Applications](https://aws.amazon.com/blogs/networking-and-content-delivery/automating-domain-delegation-for-public-applications-in-aws/)
- [Guidance to Render Unsecured PHI Unusable](https://www.hhs.gov/hipaa/for-professionals/breach-notification/guidance/index.html)

## Details

### Org and Accounts
The organization, organization units, and accounts layout is designed in accordance to the documented [Best practices for a multi-account environment](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html) and [Best practices for managing organizational units (OUs) with AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html). Specifically, the [Separating business units with significantly different policies](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/advanced-ous.html#extended-workload-oriented-ou-structure) is utilized for maximum security granularity and scaleability.

<!-- ![Organization layout](./drawings/org-and-account-layout.drawio.png) -->

<p align="center"><img src="./drawings/org-and-account-layout.drawio.png" width="55%"/></p>

### VPC Central Inspection Model
This repo follows the documented guide for North-South Inspection with AWS Network Firewall as [documented by AWS](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/inspection-deployment-models-with-AWS-network-firewall-ra.pdf). Behold, the Central Inspection Cephalopod (resemblence unintended):

<p align="center"><img src="./drawings/central-inspection.drawio.png" width="55%"/></p>

1. Public Ingress to Inspection to Workload
1. Client VPN / Direct Connect / Site-to-Site VPN to Inspection to Workload (bi-directional)
1. Workload to Inspection to Service Endpoint
1. Workload to Inspection to Internet
1. Workload to Inspection to VPC Peer / NAT / VPN (bi-directional)

Because everything deployed is a "workload", this setup enables maximum scalability and cost savings. Each additional account benefits from the same Central Inspection model, Logging, Central Service Endpoints, and Central Egress to Internet, without any additional configuration requirements.

### Delegated DNS
To align with best practices for DNS and service isolation DNS delegation is featured. The table below represents an example featuring GitLab being hosted in the shared services account.

|   | type | account | direct |
| ---: | :--- | :--- | :--- |
| domain.tld | zone |  | |
| ${\color{green}www .domain.tld}$ | CNAME | network | `www.‌sdlc.aws.domain.tld` |
| ${\color{blue}gitlab.domain.tld}$ | CNAME | network | `gitlab.svc.aws.domain.tld` |
| ${\color{red}wsu.domain.tld}$ | CNAME | network | `wsu.wsu.aws.domain.tld` |
| aws.domain.tld | zone | network | |
| ${\color{green}sdlc.aws.domain.tld}$ | zone | workload-sdlc | |
| ${\color{blue}svc.aws.domain.tld}$ | zone | shared-services | |
| ${\color{red}wsu.aws.domain.tld}$ | zone | workload-wsu | |
| ${\color{green}www .sdlc.aws.domain.tld}$ | A | workload-sdlc | load balancers |
| ${\color{blue}gitlab.svc.aws.domain.tld}$ | A | shared-services | load balancers |
| ${\color{red}wsu.wsu.aws.domain.tld}$ | A | workload-wsu | load balancers |

${\color{green}www .domain.tld‌}$ is the marketing website hosted in the sdlc account. The sdlc account also hosts multi-tenant deployments and pooled resources like api and ftp.

${\color{blue}gitlab .domain.tld}$ is the private source code management hosted in the shared services account. The shared services account also hosts applications like artifactory, jenkins, nagios, etc.

${\color{red}wsu .domain.tld}$ is an example deployment for Washington State University hosted in an isolated workload account. Workload accounts ***only*** contain services and data for that workload in accordance with data protection and privacy laws and standards.

The domain.tld zone and records directing traffic to delegated subdomains are contained in the network account, and service control policies protect anyone but superadmin from changing them. This provides complete blast radius isolation for the service to the owners, because a deployment only needs to change the records in the delegated account.

When changes to subdomain configuration need to be tested they can be done on `dev`, `tst`, and `stg` environments respective to that subdomain. For example to roll out changes on shared services, the addresses would be `application.svc-dev.aws.domain.tld`, where as changes on the network itself would be rolled out to `application.svc.aws-stg.domain.tld`. The production environment does not and should not include any indication of its specific environment; eg production does not contain `prod` or `prd` anywhere in the DNS.

AWS documentation and white papers are explicit that ***all*** services which can be designed this way should be.

## To Do
- central egress of NAT and endpoints for services
- immutable log archiving with N-day retention
- cVPN with Federated Access using Active Directory
- test Site-to-Site VPN connection between my home hardware and AWS
- implement r53 resolver
- Create a faux DR event by creating terraform code that blocks traffic in ACL of one AZs subnets
- Add multi-region active-active Postgres to EKS deployments
- Mozilla Secrets OPerationS (SOPS) implementation to keep secrets protected
- Implement StackSet Deployments
   - Disable unlimited burstable instance credits
   - delete all default VPCs in all regions of every account
   - AWS config for hipaa, CIS, NIST
      - aggregate to security account probably
   - AWS Backup with Multi-AZ and glacier
   - SCP enforcing features
      - S3 buckets never public
      - aws_ebs_snapshot_block_public_access
      - block public s3 access
   - MFA enforced organization-wide
- Centralized logging with compression and glacier archive
   - DNS logs sent to CloudWatch Log Group and S3 (with cross-regional replication and glacier)
   - ALB logs send to CloudWatch Log Group and S3 (with cross-regional replication and glacier)

## License
This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

You may use it for non-commercial and educational purposes only.