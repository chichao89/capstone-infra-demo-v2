data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  id = module.vpc.vpc_id
}


data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Check if the ECR repository exists
data "aws_ecr_repository" "existing_repository" {
  count = var.create_ecr ? 0 : 1  # Only try to fetch if we're not creating
  name = var.ecr_repository

  
}
