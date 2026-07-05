

resource "aws_lb_target_group" "tg_home" {
    name = "tg-home"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc
}
resource "aws_lb_target_group" "tg_cloth" {
    name = "tg-cloth"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc
    health_check {
      path = "/cloth/"
    }
}
resource "aws_lb_target_group" "tg_laptop" {
    name = "tg-laptop"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc
    health_check {
      path = "/laptop/"
    }
}

resource "aws_lb" "app_lb" {
    name = "app-lb"
    internal = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets = var.subnet
}

resource "aws_security_group" "alb_sg" {
    name = "alb-asg"
    vpc_id = var.vpc
    ingress {
        protocol = "TCP"
        to_port = 80
        from_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "TCP"
        to_port = 22
        from_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        to_port = 0
        from_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        }
    description = "enable 80 and 22 port"
}

resource "aws_lb_listener" "app_lb_listener" {
    load_balancer_arn = aws_lb.app_lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg_home.arn
    }
}

resource "aws_lb_listener_rule" "cloth" {
    listener_arn = aws_lb_listener.app_lb_listener.arn
    priority = 100
    action {
         type = "forward"
         target_group_arn = aws_lb_target_group.tg_cloth.arn
  }

  condition {
    path_pattern {
      values = ["/cloth*"]
    }
}
}
resource "aws_lb_listener_rule" "laptop" {
    listener_arn = aws_lb_listener.app_lb_listener.arn
    priority = 101
    action {
         type = "forward"
         target_group_arn = aws_lb_target_group.tg_laptop.arn
  }

  condition {
    path_pattern {
      values = ["/laptop*"]
    }
}
}
variable "vpc" {
    default = "vpc-0e971199fbfb98e61"
}
variable "subnet" {
    default = ["subnet-0010c4385c187ca77","subnet-0129dde8590ef0b57","subnet-0366d9f9627bde10a"]
}




