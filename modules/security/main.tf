resource "aws_security_group" "external_alb_sg" {
  name = "external-lb-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "http from internet gateway"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "https from internet gateway"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all outbound traffic"
  }
}

resource "aws_security_group" "internal_alb_sg" {
  name = "internal-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    security_groups = [ aws_security_group.frontend_app_sg.id ]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    security_groups = [ aws_security_group.frontend_app_sg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "bastion_sg" {
  name = "bastion-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "frontend_app_sg" {
  name = "frontend-app-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "TCP"
    security_groups = [ aws_security_group.external_alb_sg.id ]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    security_groups = [ aws_security_group.bastion_sg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "backend_app_sg" {
  name = "backend-app-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    security_groups = [ aws_security_group.internal_alb_sg.id ]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    security_groups = [ aws_security_group.bastion_sg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "db_sg" {
  name = "database-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "TCP"
    security_groups = [ aws_security_group.backend_app_sg.id ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [  ]
    description = "No outbound traffic allowed"
  }
}