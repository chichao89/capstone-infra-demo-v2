terraform {
  backend "s3" {
    bucket = "sctp-ce8-tfstate"
    key    = "cornelia-activity.tfstate"
    region = "ap-southeast-1"
  }
}