
# ECR Repository (with conditional creation)
resource "aws_ecr_repository" "register_service_repo" {
  count = var.create_ecr ? 1 : 0  # Only create if explicitly requested
  
  name         = var.ecr_repository
  force_delete = true  # Allows deletion of the repo when Terraform is destroying it

  tags = {
    Environment = var.environment
    Name        = var.ecr_repository
  }
}
