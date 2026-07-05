
##LOOPs in Terraform
##--> instead of writing the same resource code again and again, we can create multiple similar resources using one block\
## types of loop:
## 1. count:
##--> count is used when you want to create multiple resources with the same configuration.
## 2. for_each:
## --> for_each is used to create multiple resources with the different configuration
## 3. for
## --> for is used to read values from a list or filter data

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
output "public-ip" {
    value = [for instance in aws_instance.ec2 : instance.public_ip]
  
}

