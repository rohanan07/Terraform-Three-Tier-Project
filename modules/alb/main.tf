resource "aws_alb" "main_alb" {
  name = "main-alb"
  internal = var.internal
  load_balancer_type = "application"
  security_groups = [ var.security_group_id ]
  subnets = var.subnet_ids
  enable_http2 = true
  enable_cross_zone_load_balancing = true
  idle_timeout = 90

  tags = {
    name = "alb"
  }
}

resource "aws_lb_target_group" "main" {
  name = "${var.name_prefix}-tg"
}