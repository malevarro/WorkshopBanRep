terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "workshop-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "workshop-public-sub"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "workshop-IG"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  } 
}

resource "aws_route_table_association" "rt-assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_instance" "my-instance" {
  count = 2
  ami = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.sg.id]
  user_data = file("./script.sh")
  
  tags = {
    Name = "Ec2-Workshop-${count.index}"
  }
}

resource "aws_security_group" "sg" {
  name = "my-sg-workshop"
  description = "Allows incoming traffi on TCP ports 80 and 443"
  vpc_id = aws_vpc.default.id

  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}