resource "aws_ecs_cluster" "register_app_repo" {
  name = "register-app-repo-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "register_app_task" {
  family                   = "register-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn # Execution Role
  task_role_arn            = aws_iam_role.ecs_task_role.arn      # Task Role
  memory                   = "512"
  cpu                      = "256"

  container_definitions = jsonencode([
    {
      name      = "register-app-container",
      image     = "${aws_ecr_repository.register_service_repo.repository_url}:latest"
      memory    = 512,
      cpu       = 256,
      essential = true,
      environment = [
        { "name" : "AWS_REGION", "value" : "ap-southeast-1" },
        { "name" : "DYNAMODB_TABLE", "value" : "Users" }
      ],
      portMappings = [
        {
          containerPort = 5001,
          hostPort      = 5001
        }
      ]
    }
  ])
}

# ECS Fargate Service (No Load Balancer)
resource "aws_ecs_service" "register_app_service" {
  name            = "register-app-service"
  cluster         = aws_ecs_cluster.register_app_repo.id
  task_definition = aws_ecs_task_definition.register_app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true # ⚠️ Assigns a Public IP to the ECS Service
  }
}
