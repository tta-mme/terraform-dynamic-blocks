terraform {
  required_version = ">=1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.10"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
