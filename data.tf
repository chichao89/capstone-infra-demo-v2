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
  name = var.ecr_repository

  depends_on = [
    aws_ecr_repository.register_service_repo  # Ensure this is created before fetching it
  ]
}
