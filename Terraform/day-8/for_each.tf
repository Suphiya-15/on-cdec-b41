provider "aws" {
    region = "ap-south-1"
}


resource "aws_instance" "ec2" {
    for_each = toset(var.ami_id)
    ami = each.value
    instance_type = "t3.micro"
    tags = {
        Name = "terraform-ec2"
    }
}
variable "ami_id" {
    default = ["ami-07a00cf47dbbc844c","ami-0e38835daf6b8a2b9"]
  
}