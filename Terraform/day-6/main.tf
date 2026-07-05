

provider "aws" {
    region = "ap-south-1"
}
module "new_vpc" {
    source = "./vpc"
}

module "instance" {
    source = "./ec2"
    image_id = "ami-07a00cf47dbbc844c"
    instance_type = "t3.micro" 
    project = "cbz"
    key = "new"
    vpc_id = module.new_vpc.vpc_id
    subnet_id = module.new_vpc.pub_subnet
}