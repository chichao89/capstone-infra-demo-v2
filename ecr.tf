resource "aws_ecr_repository" "register_service" {
  name         = "group2-register-service-ecr"
  force_delete = true
}