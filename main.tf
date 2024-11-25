# Création d'un Security Group
resource "aws_security_group" "security_group_lb" {
  name_prefix = "default"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load Balancer
resource "aws_lb" "application_lb" {
  name               = "FPE-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group_lb.id]
  subnets            = var.subnets  # Utilise la variable subnets ici
}

# Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "FPE-TargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0035b5ae8bbbefd3f"
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Launch Template pour l'Auto Scaling Group
resource "aws_launch_template" "launch_template" {
  name_prefix   = "FPE-launch-template"
  image_id      = var.ami_id 
  instance_type = "t2.micro"
  user_data     = base64encode(<<-EOF
    #!/bin/bash
    echo "Instance ID: $(curl http://169.254.169.254/latest/meta-data/instance-id)" > /var/www/html/index.html
  EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  # Ajouter l'ARN du Target Group ici
  target_group_arns = [aws_lb_target_group.target_group.arn]

  tag {
    key                 = "Name"
    value               = "FPE-asg-instance"
    propagate_at_launch = true
  }
}
