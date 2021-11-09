terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.50.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {
}

# TODO: For what?
# Alernatives?
resource "aws_iam_user" "admin" {
  name = "admin"
}

# TODO: Support lookup  or create
# data "aws_organizations_organization" "example" {}
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
  feature_set = "ALL"
}

## TODO: Cloudtrail
module "secure_baseline" {
  source = "github.com/appzen-oss/terraform-aws-secure-baseline.git?ref=main"

  account_type                         = "master"
  member_accounts                      = var.member_accounts
  audit_log_bucket_name                = var.audit_s3_bucket_name
  aws_account_id                       = data.aws_caller_identity.current.account_id
  region                               = var.region
  support_iam_role_principal_arns      = [aws_iam_user.admin.arn]
  guardduty_disable_email_notification = true

  analyzer_enabled                   = false
  cloudtrail_cloudwatch_logs_enabled = false
  cloudtrail_enabled                 = false
  cloudtrail_sns_topic_enabled       = false
  config_baseline_enabled            = false
  ebs_enabled                        = false
  guardduty_enabled                  = false
  iam_enabled                        = false
  securityhub_enabled                = false
  vpc_enable                         = false
  vpc_enable_flow_logs               = false
  tags = {
    Environment = "infra"
    Product     = "security"
  }

  # Setting it to true means all audit logs are automatically deleted
  #   when you run `terraform destroy`.
  # Note that it might be inappropriate for highly secured environment.
  audit_log_bucket_force_destroy = true

  providers = {
    aws                = aws
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-northeast-3 = aws.ap-northeast-3
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-west-1      = aws.eu-west-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.sa-east-1      = aws.sa-east-1
    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
  }
}
