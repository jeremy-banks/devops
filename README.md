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
- [Prescriptive Guidance Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/org-management.html)
- [Guidance to Render Unsecured PHI Unusable](https://www.hhs.gov/hipaa/for-professionals/breach-notification/guidance/index.html)

## Notes

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
