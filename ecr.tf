resource "aws_ecr_repository" "register_service_repo" {
  name         = "${var.ecr_repository}"  # Single repo, different tags for staging/prod
  force_delete = true  # Allows deletion of the repo when Terraform is destroying it
  
  tags = {
    Environment = var.environment
    Name        = var.ecr_repository
  }

}
