terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags { tags = { Project = "SRE Bootcamp" } }
}

# we are using Ubuntu AMI as to create a server
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# this code will create the web server
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.www.id]
  user_data              = file("userdata.yml")

  tags = {
    Name = "HelloWorld"
  }

  # we can increase this value to create more web servers
  count = 1
}

data "aws_vpc" "default" {
  default = true
}

# Security group which allows access to the web server using HTTP and HTTPS
# protocols
resource "aws_security_group" "www" {
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      description      = "TLS"
      prefix_list_ids  = []
      security_groups  = []
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
    },
    {
      description      = "HTTP"
      prefix_list_ids  = []
      security_groups  = []
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
    }
  ]
  egress = [
    {
      description      = "Outbound"
      prefix_list_ids  = []
      security_groups  = []
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
    }
  ]
  tags = {
    Name = "allow_tls"
  }
}

# Final part - output external ip addresses of the servers created
output "servers_provisioned" {
  value = formatlist("http://%s", aws_instance.web.*.public_ip)
}
