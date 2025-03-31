data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

/*
data "aws_vpc" "default" {
  id = module.vpc.vpc_id
}


data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
*/