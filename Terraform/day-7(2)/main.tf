

provider "aws" {
    region = "ap-south-1"
}
module "new_vpc" {
    source = "./vpc"
    vpc_cidr = var.vpc_cidr
    pri = var.pri
    pub = var.pub
}

module "instance" {
    source = "./ec2"
    image_id = var.image_id
    instance_type = var.instance_type 
    project = var.project
    key = "new"
    vpc_id = module.new_vpc.vpc_id
    subnet_id = module.new_vpc.pub_subnet
}