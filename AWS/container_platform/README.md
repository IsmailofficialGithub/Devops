# container_platform

End-to-end **ECS Fargate platform** covering networking, containers, load balancing, data, cache, and messaging.

## Services included

| Layer | AWS services |
|---|---|
| Network | VPC, public/private subnets, IGW, NAT + **Elastic IP**, routes |
| Security | Security Groups, IAM task/execution roles, Secrets Manager |
| Containers | ECR repository, ECS cluster, Fargate service/task, CloudWatch logs |
| Load balancing | ALB, Target Group (IP mode), Listener |
| Data | RDS PostgreSQL (private) |
| Cache | ElastiCache Redis |
| Messaging | SQS queue, SNS topic, SQS←SNS subscription |
| Ops | Service discovery namespace (optional DNS), CPU/memory alarms |

```
Internet → ALB → ECS Fargate tasks (private)
                    ├─ RDS PostgreSQL
                    ├─ ElastiCache Redis
                    └─ SQS / SNS
```

## Layout

```
container_platform/
  config/env.example
  scripts/sample-app/
  terraform/
    providers.tf variables.tf main.tf outputs.tf
    modules/{vpc,security,ecs,alb,rds,elasticache,messaging}
```

## Run

```bash
cd AWS/container_platform/terraform
cp ../config/env.example terraform.tfvars
# set db_password / redis auth
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
```
