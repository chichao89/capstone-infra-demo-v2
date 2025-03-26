output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.app_cluster.name
}

output "ecs_task_family" {
  description = "The family of the ECS task definition"
  value       = aws_ecs_task_definition.app_task.family
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.register_app_service.name
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = "${var.environment}-${var.dynamodb_table_name}"
}

output "container_name" {
  description = "The name of the container running in ECS"
  value       = jsondecode(aws_ecs_task_definition.app_task.container_definitions)[0].name
}

output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.app_task.arn
}

output "ecs_service_arn" {
  description = "The ARN of the ECS service"
  value       = aws_ecs_service.register_app_service.id
}

output "ecr_repository" {
  value = aws_ecr_repository.register_service_repo.name
}

