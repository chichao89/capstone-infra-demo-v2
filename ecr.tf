resource "aws_ecr_repository" "register_service_repo" {
  name         = "group2-register-service-ecr-repo"
  force_delete = true
}