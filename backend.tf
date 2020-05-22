# Uncomment after creating the s3 bucket to save our terraform.tfstate in it
terraform {
  backend "s3" {
    bucket = "terraform-state-f789s3gy"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}