# AWS — full-stack platform projects

Two end-to-end Terraform projects that wire the core AWS networking + compute + data plane services together.

| Project | Focus |
|---|---|
| `three_tier_platform` | Classic web: VPC, EIP/NAT, EC2 Auto Scaling, ALB, RDS, S3, CloudWatch |
| `container_platform` | Containers: VPC, ECS Fargate, ALB, RDS, ElastiCache, SQS, SNS, ECR, Secrets Manager |

## Prerequisites

- AWS account + IAM credentials
- Terraform `>= 1.5`
- AWS CLI v2

```bash
aws configure
cd AWS/<project>/terraform
cp ../config/env.example terraform.tfvars
terraform init
terraform plan
# terraform apply   # creates real (billable) resources
```

> Destroy when done: `terraform destroy`
