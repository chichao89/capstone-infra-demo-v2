# Target Group for ECS
resource "aws_lb_target_group" "ecs_tg" {
  name     = "ecs-target-group"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    interval            = 30
    path                = "/health"  # Make sure you have a health check endpoint
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}
