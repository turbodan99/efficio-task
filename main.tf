provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "webserver" {
  ami                    = "ami-03362c24bc161abfd"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data              = "${data.template_file.user_data.rendered}"
  tags = {
    name = "Efficio webserver"
  }
}

resource "aws_security_group" "webserver_sg" {
  name = "allow_http"

  ingress {
    description = "Port 80 from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    description = "Everything out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = "${file("install_apache.tpl")}"
}

output "public_ip" {
  value = aws_instance.webserver.public_ip
}