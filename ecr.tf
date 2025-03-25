resource "aws_ecr_repository" "register_service_repo" {
  name         = "${var.ecr_repository}-${var.environment}"  # Different repo for staging & prod
  force_delete = true
}
