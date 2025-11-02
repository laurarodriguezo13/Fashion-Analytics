# Fashion Analytics Dashboard - Terraform Infrastructure

## Project Overview
Cloud-based fashion analytics dashboard built with AWS serverless architecture using Infrastructure as Code (Terraform) and GitOps practices.

## Architecture
- **Data Layer**: S3 for data lake storage
- **Authentication**: Amazon Cognito for user management
- **Database**: DynamoDB for fast analytics queries
- **Compute**: AWS Lambda for serverless backend
- **API**: API Gateway for REST endpoints
- **ETL**: AWS Glue for data processing
- **Frontend**: React app served via CloudFront CDN

## Deployment Method
Infrastructure deployed via Terraform from AWS CloudShell

## AWS Services Used
- S3, Cognito, DynamoDB, Lambda, API Gateway
- AWS Glue, CloudFront, CloudWatch

## Quick Start
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Authors
ESADE Cloud Solutions Project 2025

## License
Educational Project - AWS Academy
