# ECS Cluster Name
variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

# ECS Task Family
variable "ecs_task_family" {
  description = "ECS task family"
  type        = string
}

# ECS Service Name
variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

# Deployment Environment (dev, staging, prod)
variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

# DynamoDB Table Name
variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
}

# ECS Container Name
variable "container_name" {
  description = "ECS container name"
  type        = string
}

# ECR Repository Name
variable "ecr_repository" {
  description = "Name of the ECR repository"
  type        = string
  default     = "group2-register-service-ecr-repo" # Optional: Default value
}

# ECS Task Memory (MB)
variable "ecs_task_memory" {
  description = "Memory allocation for ECS task"
  type        = string
  default     = "512"  # Default value for staging
}

# ECS Task CPU (CPU units)
variable "ecs_task_cpu" {
  description = "CPU allocation for ECS task"
  type        = string
  default     = "256"  # Default value for staging
}

# ECS Container Memory (MB)
variable "ecs_container_memory" {
  description = "Memory allocation for ECS container"
  type        = string
  default     = "512"  # Default value for staging
}

# ECS Container CPU (CPU units)
variable "ecs_container_cpu" {
  description = "CPU allocation for ECS container"
  type        = string
  default     = "256"  # Default value for staging
}

# Container Port (exposed to the outside)
variable "container_port" {
  description = "Port for the container to listen on"
  type        = number
  default     = 5001
}

# Desired count for ECS service
variable "desired_count" {
  description = "The desired number of ECS service instances"
  type        = number
  default     = 1  # Default desired count for staging
}

# AWS Region (can be passed dynamically if needed)
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

# Whether to assign a public IP to ECS service
variable "assign_public_ip" {
  description = "Whether to assign a public IP to ECS service"
  type        = bool
  default     = true
}
