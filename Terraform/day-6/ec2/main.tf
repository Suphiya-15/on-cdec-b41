

resource "aws_instance" "my_instance" {
    ami = var.image_id
    instance_type = var.instance_type
    vpc_security_group_ids = [ aws_security_group.mysec.id  ]
    tags = {
        Name = "${var.project}-instance"
    }
    subnet_id = var.subnet_id
    key_name = var.key
}
resource "aws_security_group" "mysec"{
    description = "demo"
    tags ={
        Name = "${var.project}-security"
    }
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = var.vpc_id
}

variable "image_id" {}
variable "instance_type" {}
variable "project" {}
variable "subnet_id" {}
variable "key" {}
variable "vpc_id" {}