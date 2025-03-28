terraform {
  backend "s3" {
    bucket = "sctp-ce8-tfstate"
    key    = "terraform/ce8-coaching-18/${terraform.workspace}/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
  }
}