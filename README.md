# DevOps
Thank you for visiting my repo and please consider leaving a Star!

The goal of this repo is to provide a comprehensive codebase to lift-and-shift any organinzation into the ideal AWS and EKS deployment using official documented best practices, prescriptive guidance, and white papers.

## My Education and Certifications
[![Bachelor's: Genetics and Cell Biology - Washington State University](https://img.shields.io/badge/Bachelor's-Genetics_and_Cell_Biology_--_WSU_(PURSUING)-rgb(152,36,49)?style=plastic)](https://degrees.wsu.edu/degree/genetics-cell-biology/)<br>
[![Terraform Associate](https://img.shields.io/badge/Certificate-HashiCorp_Certified:_Terraform_Associate-rgb(115,73,182)?style=plastic)](https://www.credly.com/badges/736aae79-b1fd-4567-a3d2-d1e1a27ff182)<br>
[![Certified Kubernetes Administrator](https://img.shields.io/badge/Certificate-Certified_Kubernetes_Administrator-rgb(77,134,235)?style=plastic)](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/)<br>
[![Unity Prototyping UW](https://img.shields.io/badge/Certificate-Specialization_in_Game_Prototyping_with_Unity-rgb(255,255,255)?style=plastic)](https://badgr.com/public/assertions/HtqMeP7NSSaEzOeMzOowCA)

## Documentation
- [Architectural Overview](./documentation/architectural_overview.md)
- [Initial Setup](./documentation/initial_setup.md)
- [To-Do](./documentation/to_do.md)

## Features
- [x] Centralized Inspection of *all* ingress ***and*** egress traffic
- [ ] Immutable log archiving with N-day retention
- [ ] Centralized Egress of NAT and endpoints for improved security, faster speed, and cost savings
- [x] AZ IDz used so traffic stays in the intended AZs even when crossing to other VPCs through TGW
- [ ] Client VPN with Federated Access using Active Directory
- [x] Codebase optionally supports failover region for all resources, 2-4 AZs for VPCs, and public subnets with R53 and ACM

## To Do
- [ ] Add RDS to Workload Spoke
- [ ] Implement StackSet Deployments
- [ ] Mozilla Secrets OPerationS (SOPS) implementation to keep secrets protected
- [ ] Test Site-to-Site VPN connection between my home hardware and AWS
- [ ] Create a faux DR event by creating terraform code that blocks traffic in ACL of one AZs subnets

## Reference Material
- [Whitepaper: Genomics Data Transfer, Analytics, and Machine Learning using AWS Services](https://aws.amazon.com/blogs/industries/whitepaper-genomics-data-transfer-analytics-and-machine-learning-using-aws-services/)
- [Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [Best practices for OUs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html)
- [Best practices for a multi-account environment](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html)
- [Inspection Deployment Models with AWS Network Firewall](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/inspection-deployment-models-with-AWS-network-firewall-ra.pdf)
- [Centralized Inspection Architecture](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-central-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)
- [Transit Gateway Design Best Practices](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-best-design-practices.html)
- [How Transit Gateways Work in Appliance Mode](https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html#transit-gateway-appliance-scenario)
- [Prescriptive Guidance Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html)
- [Guidance to Render Unsecured PHI Unusable](https://www.hhs.gov/hipaa/for-professionals/breach-notification/guidance/index.html)

## License
This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

You may use it for non-commercial and educational purposes only.