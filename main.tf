terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "evon-tfstate"
    key    = "evon-services"
    region = "eu-north-1"
  }
}

provider "aws" {
  region  = "eu-north-1" // Stockholm
  profile = "evon"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "evon-tfstate"
  tags = {
    service = "terraform"
  }
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  acl    = "private"
}

module "go-link" {
  source = "./services/go-link"
}

module "stock-platform" {
  source = "./services/stock-platform"
}
