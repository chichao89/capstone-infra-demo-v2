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
      image     = "${aws_ecr_repository.register_service_repo.repository_url}:${var.environment}"
      essential = true
      memory    = var.ecs_container_memory   # Dynamic memory for container
      cpu       = var.ecs_container_cpu      # Dynamic CPU for container
      environment = [
        { "name" : "AWS_REGION", "value" : var.aws_region },
        { "name" : "DYNAMODB_TABLE", "value" : var.dynamodb_table_name }
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

# ALB Security Group for ALB (public access)
resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from the internet on port 80 (HTTP)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the Application Load Balancer (ALB)
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  idle_timeout {
    seconds = 60
  }
}

# Create an HTTP Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "OK"
    }
  }
}

# Create Target Group for ECS Service
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = var.container_port  # Container port for the ECS service
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    interval            = 30
    path                = "/health"  # Health check path for ECS tasks
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}

# ECS Service with ALB Integration
resource "aws_ecs_service" "register_app_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count   # Dynamic desired count based on environment
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets  # Assigning public subnets for ALB accessibility
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = var.assign_public_ip  # Optionally assign public IP based on environment
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn  # Pointing to the Target Group
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
