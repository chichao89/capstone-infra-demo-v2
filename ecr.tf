resource "aws_ecr_repository" "register_service_repo" {
  name         = var.ecr_repository
  force_delete = true
}