resource "aws_ecs_cluster" "register_app_repo" {
  name = "register-app-repo"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "flask_app_task" {
  family                   = "flask-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn # Execution Role
  task_role_arn            = aws_iam_role.ecs_task_role.arn      # Task Role
  memory                   = "512"
  cpu                      = "256"

  container_definitions = jsonencode([
    {
      name      = "flask-app-container",
      image     = "${aws_ecr_repository.register_service.repository_url}:latest"
      memory    = 512,
      cpu       = 256,
      essential = true,
      environment = [
        { "name" : "AWS_REGION", "value" : "us-east-1" }
      ],
      portMappings = [
        {
          containerPort = 5000,
          hostPort      = 5000
        }
      ]
    }
  ])
}

# ECS Fargate Service (No Load Balancer)
resource "aws_ecs_service" "flask_app_service" {
  name            = "flask-app-service"
  cluster         = aws_ecs_cluster.register_app_repo.id
  task_definition = aws_ecs_task_definition.flask_app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true # ⚠️ Assigns a Public IP to the ECS Service
  }
}
