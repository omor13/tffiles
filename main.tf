terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
#################  vpc_production #####################
resource "aws_vpc" "vpc_production" {
    cidr_block = "192.168.5.0/24"
    tags = {
      "env" = "production"
    }
}

#################  subnet_web #####################

resource "aws_subnet" "subnet_web" {
  vpc_id     = aws_vpc.vpc_production.id
  cidr_block = "192.168.5.0/27"

  tags = {
    "env" = "production"
  }
}

#################  subnet_db #####################

resource "aws_subnet" "subnet_db" {
  vpc_id     = aws_vpc.vpc_production.id
  cidr_block = "192.168.5.32/28"

  tags = {
    "env" = "production"
  }
}

################# nic1 #####################
resource "aws_network_interface" "nic1" {
  subnet_id   = aws_subnet.subnet_web.id
  private_ips = ["192.168.5.10"]

  tags = {
    env = "production"
  }
}
################# webserver #####################
resource "aws_instance" "webserver" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.nic1.id
    device_index         = 0
  }
}