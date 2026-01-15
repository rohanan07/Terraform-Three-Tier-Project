resource "aws_launch_template" "backend_launch_template" {
  name = "backend_launch_template"
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  vpc_security_group_ids = [ var.security_group_id ]

  user_data = ""

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      name = "backend-app-instance-lt"
    }
  }
}

resource "aws_autoscaling_group" "backend_asg" {
  name = "backend-asg"
  min_size = 2
  max_size = 4
  desired_capacity = 2
  vpc_zone_identifier = var.subnet_ids
  health_check_type = "ELB"
  health_check_grace_period = 600
  target_group_arns = var.target_group_arns

  launch_template {
    id = aws_launch_template.backend_launch_template.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key = "name"
    value = "backend-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}