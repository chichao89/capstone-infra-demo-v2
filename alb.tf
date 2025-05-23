resource "aws_lb" "app_alb" {
  name                          = var.alb_name
  internal                      = false
  load_balancer_type            = "application"
  security_groups               = [aws_security_group.alb_sg.id]
  subnets                       = module.vpc.public_subnets
  enable_deletion_protection    = false
  enable_cross_zone_load_balancing = true

  idle_timeout = 60  # Correct argument (not a block)
}
