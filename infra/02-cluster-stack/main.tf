terraform {
  backend "s3" {
    bucket = "workshop-remote-backend-bucket-180294221572"
    key    = "server/terraform.state"
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
  default_tags {
    tags = var.tags
  }
}

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.id]
      command     = "aws"
    }
  }
}