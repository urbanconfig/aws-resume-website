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
