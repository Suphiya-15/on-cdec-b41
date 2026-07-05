

terraform {
    backend "s3" {
        bucket = "bucket_name"
        region = "ap-south-1"
        key = "terraform.tfstate"
      
    }
}
provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t3.micro"
    tags = {
        Name = "terraform-ec2"
    }
}
