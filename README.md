# DevOps

## Project Goals
1. Create ideal and comprehensive codebase to "lift and shift" an org into AWS and EKS
1. Also to demonstrate my expertise in the tool and provide a framework for mentorship
1. Follow documented best practice use of Terraform, EKS, and Helm in AWS

## Documentation
- [Architectural Overview](./documentation/architectural_overview.md)
- [Initial Setup](./documentation/initial_setup.md)
- [Processes](./documentation/processes.md)
- [To-Do](./documentation/to_do.md)

## Reference Materials
- [Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [Best practices for OUs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous_best_practices.html)
- [Best practices for a multi-account environment](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_best-practices.html)
- [Inspection Deployment Models with AWS Network Firewall](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/inspection-deployment-models-with-AWS-network-firewall-ra.pdf)
- [Centralized Inspection Architecture](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)
- [Transit Gateway Design Best Practices](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-best-design-practices.html)
- [How Transit Gateways Work in Appliance Mode](https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html#transit-gateway-appliance-scenario)
- [Prescriptive Guidance Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html)
- [Guidance to Render Unsecured PHI Unusable](https://www.hhs.gov/hipaa/for-professionals/breach-notification/guidance/index.html)

## Notes

inbound
    inbound vpc
    tgw
    inspection vpc
    tgw
    spoke vpc

outbount
    spoke vpc
    tgw
    inspection vpc
    tgw
    outbound vpc


you need to establish and define what a "spoke" is now

and its interaction with the network vpc
especially the connection with the post-inspection route table

then you need to identify a firewall policy that 'works for now' so you can esablish a k8s cluster

*inbound routes
*pre-inspection tgw routes
*    routes
    associations
post-inspection tgw routes
    routes
    associations
*inspection  vpc
*outbound routes

outbound endpoints

workloads vpc

rework the eks stuff
append k8s 'bare meta'

impelement federated access using active directory and windows server???
