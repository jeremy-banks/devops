# DevOps
Thank you for visiting! Please consider leaving a [![GitHub stars](https://img.shields.io/github/stars/jeremy-banks/devops?style=social)](https://github.com/your-username/your-repo)

The goal of this repo is to provide a comprehensive codebase for me to lift-and-shift any organinzation into an ideal AWS and EKS deployment using documented best practices.

## My Education and Certifications
[![Bachelor's: Genetics and Cell Biology - Washington State University](https://img.shields.io/badge/Bachelor's-Genetics_and_Cell_Biology_--_WSU_(CURRENTLY_PURSUING)-rgb(152,36,49))](https://degrees.wsu.edu/degree/genetics-cell-biology/) [![Terraform Associate](https://img.shields.io/badge/Certificate-HashiCorp_Certified:_Terraform_Associate-rgb(115,73,182))](https://www.credly.com/badges/736aae79-b1fd-4567-a3d2-d1e1a27ff182) [![Certified Kubernetes Administrator](https://img.shields.io/badge/Certificate-Certified_Kubernetes_Administrator-rgb(77,134,235))](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/) [![Unity Prototyping UW](https://img.shields.io/badge/Certificate-Specialization_in_Game_Prototyping_with_Unity-white)](https://badgr.com/public/assertions/HtqMeP7NSSaEzOeMzOowCA)

## Repo Features

#### Security Control Policies
Limitations on S3 access and IAM rights restricted by the OU.

#### Network Topology
For maximum security and scalability the [Multi-Region Inspection with AWS Network Firewall](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/inspection-deployment-models-with-AWS-network-firewall-ra.pdf) model is used, this codebase dynamically supports 2-6 availability zones, and optionally includes failover regions for all resources.

## Documentation
- [Initial Setup](./documentation/initial_setup.md)
- [To-Do](./documentation/to_do.md)

## Reference Material
- [Whitepaper: Genomics Data Transfer, Analytics, and Machine Learning using AWS Services](https://aws.amazon.com/blogs/industries/whitepaper-genomics-data-transfer-analytics-and-machine-learning-using-aws-services/)
- [Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [Best practices for OUs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html)
- [Best practices for a multi-account environment](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html)
- [Inspection Deployment Models with AWS Network Firewall](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/inspection-deployment-models-with-AWS-network-firewall-ra.pdf)
- [Centralized Inspection Architecture](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)
- [Transit Gateway Design Best Practices](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-best-design-practices.html)
- [How Transit Gateways Work in Appliance Mode](https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html#transit-gateway-appliance-scenario)
- [Prescriptive Guidance Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html)
- [Guidance to Render Unsecured PHI Unusable](https://www.hhs.gov/hipaa/for-professionals/breach-notification/guidance/index.html)