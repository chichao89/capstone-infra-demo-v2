resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = var.ecs_task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  memory                   = "512"
  cpu                      = "256"

  container_definitions = jsonencode([
    {
      name      =  "${var.container_name}",
      image     = "${aws_ecr_repository.register_service_repo.repository_url}:latest",
      memory    = 512,
      cpu       = 256,
      essential = true,
      environment = [
        { "name" : "AWS_REGION", "value" : "ap-southeast-1" },
        { "name" : "DYNAMODB_TABLE", "value" : "${var.dynamodb_table_name}-${var.environment}" }
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
resource "aws_ecs_service" "register_app_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true # ⚠️ Assigns a Public IP to the ECS Service
  }
}
