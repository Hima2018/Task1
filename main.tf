terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "us-east-1"
  access_key = "AKIAQ6WUJP42VJBFZWNK"
  secret_key = "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"
}
