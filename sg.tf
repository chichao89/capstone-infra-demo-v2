module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "group2-vpc"
  cidr = "10.0.0.0/16"

  azs                = ["ap-southeast-1a", "ap-southeast-1b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway = false
}

# Security Group for ECS Service
resource "aws_security_group" "ecs_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Open to all (use your IP for security)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
