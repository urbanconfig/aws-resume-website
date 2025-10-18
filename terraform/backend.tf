terraform {
  backend "s3" {
    bucket              = "tfstate-urbanconfig-cloud-resume"
    key                 = "terraform.tfstate"
    region              = "eu-central-1"
    use_lockfile        = true
  }
}