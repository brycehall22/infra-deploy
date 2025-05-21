# Infrastructure Deployment with Terraform and GitHub Actions

![Terraform](https://img.shields.io/badge/Terraform-1.6.0+-blue)
![AWS](https://img.shields.io/badge/AWS-Lambda-orange)
![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-green)

A CI/CD pipeline for deploying AWS infrastructure using Terraform and GitHub Actions. This project automates the provisioning of AWS Lambda functions and related IAM resources through infrastructure as code.

## Overview

This repository contains Terraform configurations for deploying a Python Lambda function to AWS with the appropriate IAM roles and permissions. The deployment process is automated using GitHub Actions workflows that plan and apply Terraform changes when code is pushed or pull requests are created.

## Architecture

- **AWS Lambda Function**: Python 3.12 runtime with configurable timeout
- **IAM Role**: Custom execution role with logging permissions
- **CI/CD Pipeline**: GitHub Actions workflow for automated infrastructure deployment

## Repository Structure

```
.
├── .github/workflows/
│   ├── iam.tf               # IAM role and policy definitions
│   ├── lambda.tf            # Lambda function configuration
│   ├── outputs.tf           # Terraform output variables
│   ├── provider.tf          # AWS provider configuration
│   ├── tf-deploy.yaml       # GitHub Actions workflow definition
│   └── lambda_package.zip   # Packaged Lambda code (not shown in files)
└── README.md                # This documentation
```

## Terraform Resources

### IAM Configuration (iam.tf)
- Creates a Lambda execution role (`brycehall_lambda_exec_role`)
- Attaches AWS Lambda basic execution policy for CloudWatch logging

### Lambda Configuration (lambda.tf)
- Defines a Python 3.12 Lambda function
- Sets handler to `test_script.lambda_handler`
- Configures a 10-second timeout

### Provider Configuration (provider.tf)
- AWS provider configuration for US East 2 (Ohio) region
- Requires Terraform 1.6.0+ and AWS provider ~> 5.0

## CI/CD Workflow

The GitHub Actions workflow (`tf-deploy.yaml`) automates the infrastructure deployment process:

### Trigger Events
- Pull requests to the `main` branch
- Pushes to branches with prefixes: `feature/`, `feat/`, `fix/`, or `wip/`

### Workflow Steps
1. **Checkout**: Clones the repository
2. **Setup**: Installs Terraform 1.6.1
3. **AWS Authentication**: Assumes the designated AWS role
4. **Terraform Init**: Initializes Terraform with backend configuration
5. **Terraform Validate**: Validates configuration syntax
6. **Terraform Plan**: Creates an execution plan and uploads as an artifact
7. **PR Comment**: Adds plan results as a comment on pull requests
8. **Terraform Apply**: For PRs, automatically applies changes if plan succeeds
9. **Apply Comment**: Updates PR with apply results

## Getting Started

### Prerequisites
- AWS account with appropriate permissions
- GitHub repository with Actions enabled

### Setup Instructions
1. Fork or clone this repository
2. Set up the AWS IAM role for GitHub Actions to assume:
   ```
   arn:aws:iam::211507861780:role/Terraform-AWS
   ```
3. Ensure the Lambda code is packaged as `lambda_package.zip` in the `.github/workflows` directory
4. Push to a feature branch or create a pull request to trigger the workflow

### Modifying the Infrastructure
- Edit the Terraform files to change infrastructure configuration
- Update Lambda code and repackage as needed
- Commit and push changes to trigger the CI/CD workflow

## Security Notes
- The workflow uses GitHub's OIDC provider to authenticate with AWS without storing credentials
- IAM role permissions follow the principle of least privilege
- All infrastructure changes are documented in pull request comments for review

## Output
After successful deployment, the workflow will output:
- Lambda function name: `brycehall_lambda`
