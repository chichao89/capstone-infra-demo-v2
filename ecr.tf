
# ECR Repository (with conditional creation)
resource "aws_ecr_repository" "register_service_repo" {
  count        = length(data.aws_ecr_repository.existing_repository.id) == 0 ? 1 : 0
  name         = var.ecr_repository
  force_delete = true  # Allows deletion of the repo when Terraform is destroying it

  tags = {
    Environment = var.environment
    Name        = var.ecr_repository
  }
}
