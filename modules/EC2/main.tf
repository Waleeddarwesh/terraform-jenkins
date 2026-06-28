########################################
# Application Security Group
########################################

resource "aws_security_group" "app_sg" {

  name   = "app-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.ssh_ip
    ]
  }

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "app-sg"
  }

}

########################################
# ALB Security Group
########################################

resource "aws_security_group" "alb_sg" {

  name   = "alb-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "alb-sg"
  }

}

########################################
# EC2 Instances
########################################

resource "aws_instance" "app" {

  count = var.instance_count

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = values(var.public_subnet_ids)[
    count.index % length(values(var.public_subnet_ids))
  ]

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  tags = {
    Name = "app-server-${count.index + 1}"
  }

}

########################################
# Application Load Balancer
########################################

resource "aws_lb" "app_alb" {

  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = values(var.public_subnet_ids)

  tags = {
    Name = "app-alb"
  }

}

########################################
# Target Group
########################################

resource "aws_lb_target_group" "app_tg" {

  name     = "app-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {

    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2

    interval = 30
    timeout  = 5

    path = "/"

    protocol = "HTTP"

    matcher = "200"
  }

  tags = {
    Name = "app-tg"
  }

}

########################################
# Listener
########################################

resource "aws_lb_listener" "app_listener" {

  load_balancer_arn = aws_lb.app_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.app_tg.arn

  }

}

########################################
# Target Group Attachments
########################################

resource "aws_lb_target_group_attachment" "app_attachment" {

  count = length(aws_instance.app)

  target_group_arn = aws_lb_target_group.app_tg.arn

  target_id = aws_instance.app[count.index].id

  port = 80

}