terraform {
    required_version = "1.1.9"
    
    backend "s3" {
        bucket = "maclayzie"
        key    = "terraform/api"
        region = "us-east-1"
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
    }
}

data "terraform_remote_state" "platform" {
  backend = "s3"
  config = {
        bucket = "maclayzie"
        key    = "terraform/platform"
        region = "us-east-1"
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
        bucket = "maclayzie"
        key    = "terraform/api-shared"
        region = "us-east-1"
  }
}

provider "aws" {
    region  = "us-east-1"
    alias   = "main"
}

data "aws_region" "current" {
    provider = aws.main
}
