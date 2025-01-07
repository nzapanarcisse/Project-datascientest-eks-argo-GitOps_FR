data "aws_ami" "debian-12" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["debian-12-amd64*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_launch_configuration" "fall-project_bastion" {
  name_prefix = "${var.namespace}-bastion-"
  image_id                         = data.aws_ami.debian-12.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.key_name
  user_data = "${file("install_bastion.sh")}"
  security_groups      = [var.sg_pub_id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "fall-project_bastion" {
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.fall-project_bastion.name
  vpc_zone_identifier  = var.vpc.public_subnets

  tag {
    key                 = "Name"
    value               = "fall-project-bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "Type"
    value               = "public-bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "fall-project"
    value               = true
    propagate_at_launch = true
  }

}
