resource "aws_instance" "bastion_host" {
  instance_type = var.instance_type
  ami = var.ami_id
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = true
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  tags = {
    name = "bastion-host"
  }
}

resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  tags = {
    name = "bastion-eip"
  }
}
resource "aws_eip_association" "bastion_eip_assc" {
  instance_id = aws_instance.bastion_host.id
  allocation_id = aws_eip.bastion_eip.id
}