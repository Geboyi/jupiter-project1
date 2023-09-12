provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "web" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "web_a" {
  vpc_id = aws_vpc.web.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "web_b" {
  vpc_id = aws_vpc.web.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_alb" "web" {
  name = "web-alb"
  subnets = [aws_subnet.web_a.id, aws_subnet.web_b.id]
  security_groups = [aws_security_group.web.id]
}

resource "aws_autoscaling_group" "web" {
  name = "web-asg"
  min_size = 2
  max_size = 2
  desired_capacity = 2
  vpc_zone_ids = [aws_subnet.web_a.id, aws_subnet.web_b.id]
  launch_configuration = aws_launch_configuration.web.name
  health_check_grace_period = 300
}

resource "aws_launch_configuration" "web" {
  image_id = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  key_name = "tests"
  security_groups = [aws_security_group.web.id]
  user_data = "${file("data.sh")}"
}

resource "aws_security_group" "web" {
  name = "web-sg"
  vpc_id = aws_vpc.web.id

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "tcp"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
