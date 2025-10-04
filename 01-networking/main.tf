terraform {
  backend "s3" {
    bucket = "workshop-remote-backend-bucket-180294221572"
    key    = "networking/terraform.state"
    region = "us-east-1"
    use_lockfile = true
    # dynamodb_table = "workshop-state-lock" - Old Versions
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.auth.region
  assume_role { 
    role_arn = var.auth.assume_role_arn
  }
}