# DevOps

## Project Details
1. Codebase to demonstrate documented best practice use of Terraform, EKS, and Helm in AWS
1. Repo includes nginx welcome page deployed to EKS

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

public = public
intra = tgw /28
private = private
private = firewall

workloads vpc
    pre-inspection route table to inspection vpc

inspection vpc
    post-inspection route table to outgoing vpc




vpc
    ingress
        /16, 2 pub subnets
    egress
        /16, 2 pub subnets
    inspection
        /16, 2 pvt subnets
    tgw
    example deployment
        /16, 2 pvt subnets
    route tables for all
    ram sharing ingress and maybe egress??
    lots of testing

rework the eks stuff
append k8s 'bare meta'

impelement federated access using active directory and windows server???
