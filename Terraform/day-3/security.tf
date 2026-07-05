
provider "aws" {
    region = var.ami
}

resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.instance
    vpc_security_group_ids= [aws_security_group.mysec.id]
}

resource "aws_security_group" "mysec"{
    region = var.region
    description = "demo"
    name = "my-security"
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = vpc-0e971199fbfb98e61
}

variable "ami" {
    default =ami-07a00cf47dbbc844c
}
variable "instance" {
    default = "t3.micro"
}
variable "region" {
    default = "ap-south-1"
}

output "public" {
    value = aws_instance.ec2.public_ip
}
output "demo" {
    value = "my name is suphiya"
}