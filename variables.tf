variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_task_family" {
  description = "ECS task family"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}
variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
}
variable "container_name" {
  description = "ecs container name"
  type        = string
}

variable "ecr_repository" {
  description = "Name of the ECR repository"
  type        = string
  default     = "group2-register-service-ecr-repo" # Optional: Default value
}
