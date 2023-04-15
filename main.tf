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

// ACM certificate in US-EAST-1
provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "evon"
}

data "aws_acm_certificate" "evon-certificate" {
  provider    = aws.us-east-1
  domain      = "*.evon.fi"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

module "email" {
  source = "./services/email"
}

module "go-link" {
  source              = "./services/go-link"
  acm-certificate-arn = data.aws_acm_certificate.evon-certificate.arn
}

module "stock-platform" {
  source              = "./services/stock-platform"
  acm-certificate-arn = data.aws_acm_certificate.evon-certificate.arn
  email-lambda-arn    = module.email.email-lambda-arn
}

module "cdn" {
  source              = "./services/cdn"
  acm-certificate-arn = data.aws_acm_certificate.evon-certificate.arn
}
