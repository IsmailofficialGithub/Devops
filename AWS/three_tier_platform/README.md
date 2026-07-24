# three_tier_platform

End-to-end **3-tier AWS web platform** covering network, compute, load balancing, database, and observability.

## Services included

| Layer | AWS services |
|---|---|
| Network | VPC, public/private subnets (multi-AZ), Internet Gateway, NAT Gateway + **Elastic IP**, route tables |
| Security | Security Groups, IAM instance profile/role |
| Compute | EC2 Launch Template, Auto Scaling Group |
| Load balancing | Application Load Balancer, Target Group, Listener, Listener rules |
| Data | RDS (PostgreSQL), subnet group, parameter group |
| Storage | S3 bucket (ALB/access logs) |
| Ops | CloudWatch log group, CPU alarm, ASG target-tracking policy |

```
Internet
   │
  ALB (public subnets)
   │
 EC2 ASG (private app subnets)
   │
 RDS PostgreSQL (private db subnets)
```

## Layout

```
three_tier_platform/
  config/env.example
  scripts/userdata.sh
  terraform/
    providers.tf
    variables.tf
    main.tf
    outputs.tf
    modules/{vpc,security,compute,alb,rds}
```

## Run

```bash
cd AWS/three_tier_platform/terraform
cp ../config/env.example terraform.tfvars
# edit region, key_name, db_password
terraform init
terraform plan
terraform apply
terraform output alb_dns_name
terraform destroy
```
