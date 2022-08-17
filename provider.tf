# Define AWS as our provider
provider "aws" {
  region = "${var.aws_region}"
  profile = "default"
  shared_credentials_files = ["$HOME/.aws/credentials"]
}

# Remote State File
terraform {
  backend "s3" {
    bucket = ""
    key    = "tf-state/us-east-2"
    region = "us-east-2"
    profile = "default"
    shared_credentials_file = "$HOME/.aws/credentials"
  }
}
