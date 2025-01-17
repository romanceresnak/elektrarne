terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.1"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.4.0"
    }
  }
}