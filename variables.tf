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
variable "service_name" {
  description = "service name"
  type        = string
}
