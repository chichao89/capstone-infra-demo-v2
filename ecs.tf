# ECS Cluster Definition
resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# CloudWatch Log Group for ECS Task Logs
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.ecs_task_family}"
  retention_in_days = 7
}

# ECS Task Definition for App
resource "aws_ecs_task_definition" "app_task" {
  family                   = var.ecs_task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  memory                   = var.ecs_task_memory  # Dynamic memory from tfvars
  cpu                      = var.ecs_task_cpu     # Dynamic CPU from tfvars

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image =   "${aws_ecr_repository.register_service_repo.repository_url}:${var.environment}" 
      essential = true
      memory    = var.ecs_container_memory   # Dynamic memory for container
      cpu       = var.ecs_container_cpu      # Dynamic CPU for container
      environment = [
        { "name" : "AWS_REGION", "value" : var.aws_region },
        { "name" : "DYNAMODB_TABLE", "value" : "${var.dynamodb_table_name}" }
      ],
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ],
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.ecs_task_family}"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = var.container_name
      }
    }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "register_app_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count   # Dynamic desired count based on environment
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = var.assign_public_ip  # Assign public IP dynamically based on environment
  }
}
