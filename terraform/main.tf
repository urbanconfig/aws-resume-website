terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "backend" {
  source              = "./modules/remote_backend"
  iam_user_name       = var.iam_user_name
  tfstate_bucket_name = var.tfstate_bucket_name
}

module "dns_and_acm" {
  source          = "./modules/route53_with_acm"
  dns_zone_domain = var.dns_zone_domain
  dns_record_ttl  = var.dns_record_ttl
  cert_region     = var.cert_region
}