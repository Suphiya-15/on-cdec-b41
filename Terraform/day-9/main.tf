

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t3.micro"
    tags = {
        Name = "terraform-ec2"
    }
    provisioner "local-exec" {
        command = "touch abc.txt"
      
    }
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("new")
        host = self.public_ip
      
    }
    provisioner "file" {
        source = "web.sh"
        destination = "/home/ubuntu/web.sh"
      
    }
    provisioner "remote-exec" {
        inline = [
            "bash /home/ubuntu/web.sh"
        ]
      
    }
    

}


