terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "eu-north-1" // Stockholm
  profile = "evon"
}

module "go-link" {
  source = "./services/go-link"
}
