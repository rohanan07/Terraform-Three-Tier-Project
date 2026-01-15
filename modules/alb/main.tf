resource "aws_lb" "main_alb" {
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
  port = var.target_group_port
  protocol = "HTTP"
  vpc_id = var.vpc_id

   health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-299"
  }

  deregistration_delay = 30

  stickiness {
    type = "lb_cookie"
    cookie_duration = 86400
    enabled = true
  }

  tags = {
    name = "frontend-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_lb.main_alb.arn
  port = 443
  protocol = "HTTPS"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
