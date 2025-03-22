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
      name      = var.ecs_service_name,
      image     = "${aws_ecr_repository.register_service_repo.repository_url}:latest"
      memory    = 512
      cpu       = 256
      essential = true
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
