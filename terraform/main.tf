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

provider "aws" {
  alias  = "us_region"
  region = var.us_region
}

module "backend" {
  source              = "./modules/remote_backend"
  iam_user_name       = var.iam_user_name
  tfstate_bucket_name = var.tfstate_bucket_name
}

module "dns_and_acm" {
  providers = {

    aws.us_region = aws.us_region
  }

  source          = "./modules/route53_with_acm"
  dns_zone_domain = var.dns_zone_domain
  dns_record_ttl  = var.dns_record_ttl
}

module "s3_website" {
  source                = "./modules/s3_website"
  website_bucket        = var.website_bucket
  force_destroy         = var.force_destroy
  enable_versioning     = var.enable_versioning
  index_document_suffix = var.index_document_suffix
  region                = var.region
}

module "s3_cloudfront" {
  source                      = "./modules/s3_couldfront"
  index_document              = module.s3_website.index_document
  bucket_regional_domain_name = module.s3_website.bucket_regional_domain_name
  s3_bucket_id                = module.s3_website.s3_bucket_id
  ssl_certificate_arn         = module.dns_and_acm.ssl_certificate_arn
  route53_zone_id             = module.dns_and_acm.route53_zone_id
  root_domain                 = module.dns_and_acm.root_domain
}

module "lambda_and_dynamodb" {
  source      = "./modules/lambda_and_dynamodb"
  table_name  = var.table_name
  root_domain = module.dns_and_acm.root_domain
}