

provider "aws" {
    region = "ap-south-1"
}

resource "aws_launch_template" "hometemp" {
    name = "hometemp"
    image_id = var.image
    key_name = var.key_pair
    instance_type = var.instance_type
    vpc_security_group_ids = [var.security]
    user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl enable apache2
    systemctl start apache2
    echo "<h1>Welcome to Cloudblitz..</h1>" >/var/www/html/index.html
    EOF
    )
}

resource "aws_launch_template" "clothtemp" {
    name = "clothtemp"
    image_id = var.image
    key_name = var.key_pair
    instance_type = var.instance_type
    vpc_security_group_ids = [var.security]
    user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl enable apache2
    systemctl start apache2
    mkdir /var/www/html/cloth
    echo "<h1>This is Cloth Section..</h1>" >/var/www/html/cloth/index.html
    EOF
    )
}

resource "aws_launch_template" "laptoptemp" {
    name = "laptoptemp"
    image_id = var.image
    key_name = var.key_pair
    instance_type = var.instance_type
    vpc_security_group_ids = [var.security]
    user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl enable apache2
    systemctl start apache2
    mkdir /var/www/html/laptop
    echo "<h1>SALE..SALE..SALE... SALE on Laptop</h1>" >/var/www/html/laptop/index.html
    EOF
    )
}

resource "aws_autoscaling_group" "asg_home" {
    name = "asg-home"
    min_size = var.min
    max_size = var.max
    desired_capacity = var.desire
    availability_zones = var.az
    launch_template {
              id = aws_launch_template.hometemp.id 
              version = "$Latest"   
            }
    target_group_arns = [
                aws_lb_target_group.tg_home.arn
            ]
}
resource "aws_autoscaling_policy" "asp-home" {
    name = "asp-home"
    autoscaling_group_name = aws_autoscaling_group.asg_home.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
  

} 

resource "aws_autoscaling_group" "asg_cloth" {
    name = "asg-cloth"
    min_size = var.min
    max_size = var.max
    desired_capacity = var.desire
    availability_zones = var.az
    launch_template {
              id = aws_launch_template.clothtemp.id 
              version = "$Latest" 
            }
    target_group_arns = [
                aws_lb_target_group.tg_cloth.arn
            ]
}
resource "aws_autoscaling_policy" "asp-cloth" {
    name = "asp-cloth"
    autoscaling_group_name = aws_autoscaling_group.asg_cloth.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }

} 

resource "aws_autoscaling_group" "asg_laptop" {
    name = "asg-laptop"
    min_size = var.min
    max_size = var.max
    desired_capacity = var.desire
    availability_zones = var.az
    launch_template {
              id = aws_launch_template.laptoptemp.id 
              version = "$Latest"
            }
    target_group_arns = [
                aws_lb_target_group.tg_laptop.arn
            ]
}
resource "aws_autoscaling_policy" "asp-laptop" {
    name = "asp-laptop"
    autoscaling_group_name = aws_autoscaling_group.asg_laptop.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }

} 

variable "image" {
    default =  "ami-07a00cf47dbbc844c"
}

variable "instance_type" {
    default = "t3.micro"
} 

variable "security" {
    default = "sg-0676df91307f15028"
}

variable "key_pair" {
     default = "new" 
}

variable "min" {
    default = "2"
}

variable "max" {
    default = "5"
}

variable "desire" {
    default = "2"
}

variable "az" {
    default = ["ap-south-1a","ap-south-1b","ap-south-1c"]
}

