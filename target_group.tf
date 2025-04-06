resource "aws_lb_target_group" "ecs_tg" {
  name     = var.target_group_name
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  target_type = "ip"  # Set target type to "ip" for compatibility with awsvpc

  health_check {
    interval            = 30
    path                = "/health"  # Make sure you have a health check endpoint
    port                = var.container_port
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}
