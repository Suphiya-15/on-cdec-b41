

resource "aws_vpc" "my_vpc" {
  tags = {
    Name = "${var.project}-vpc" 
   } 
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "pri_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.project}-pri-subnet"
    }  
    cidr_block = var.pri
}

resource "aws_subnet" "pub_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.project}-pub-subnet"
    }  
    cidr_block = var.pub
    map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "my_igw" {
    tags = {
        Name = "${var.project}-igw"
    }
    vpc_id = aws_vpc.my_vpc.id
}
resource "aws_default_route_table" "my_rt" {
    default_route_table_id = aws_vpc.my_vpc.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}
variable "project" {
    default = "cbz"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "pri" {
    default = "10.0.0.0/20"
}

variable "pub" {
    default = "10.0.16.0/20"
}
output "vpc_id" {
    value = aws_vpc.my_vpc.id
  
}
output "pri_subnet" {
    value = aws_subnet.pri_subnet.id
  
}
output "pub_subnet" {
    value = aws_subnet.pub_subnet.id
  
}