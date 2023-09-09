
provider "aws" {
  region = "eu-west-1"
}

data "terraform_remote_state" "remote" {
  backend = "s3"
  config =  {
    bucket = "technologiesoutcomes-terraform-backend"
    key = "3tier-baseinfra.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_network_interface" "bar" {
  subnet_id       = "${data.terraform_remote_state.remote.outputs.public_subnets[0]}"
  security_groups = [aws_security_group.ec2_web.id]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "bar" {
  ami           = "ami-05432c5a0f7b1bfd0"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.bar.id
    device_index         = 0
  }

  user_data = <<EOF
#!/bin/bash
DBRootPassword=myDBRootPwd
DBName=myDB
DBUser=myUser
DBPassword=myUserPwd

sudo dnf -y update
sudo dnf install wget php-mysqlnd httpd php-fpm php-mysqli mariadb105-server php-json php php-devel stress -y

sudo systemctl enable httpd
sudo systemctl enable mariadb
sudo systemctl start httpd
sudo systemctl start mariadb

sudo mysqladmin -u root password $DBRootPassword

sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
sudo tar -zxvf latest.tar.gz
sudo cp -rvf wordpress/* .
sudo rm -R wordpress
sudo rm latest.tar.gz

sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php

sudo usermod -a -G apache ec2-user   
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} \;
sudo find /var/www -type f -exec chmod 0664 {} \;

sudo echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
sudo echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
sudo echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
sudo echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
sudo mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo rm /tmp/db.setup
EOF

  key_name = aws_key_pair.masterkey4.key_name
  credit_specification {
    cpu_credits = "unlimited"
  }
}


resource "aws_security_group" "ec2_web" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${data.terraform_remote_state.remote.outputs.vpc_id}"

  #ingress {
  #  description     = "TLS from VPC"
  #  from_port       = 80
  #  to_port         = 80
  #  protocol        = "tcp"
  #  security_groups = [aws_security_group.lb_sg.id]
  #}

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    ##cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_key_pair" "masterkey4" {
  key_name   = "masterkey4"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmulVM6PaIHE2L/wBgRlnyKtarAeMCQdXo4Yh28qbV8iF/f0OwEL6nIjaGtc2lL2TDvy9nRokeFSFyQxvHW8WisS6ZfoEP0rMA1UObw4TvpB+NVfxp4Mt3ffce9yD0xnZooBsPiRVtyAt83SJxRRZ2i7xlF2efHoO5D9USm1ccpxxu9NpG1zW0UAIw5lJBWqHH67WsXOrUlwsRWlMmoRk7SCeN8q2yabchq08LcE4kNrmGoa2dppgFiWwa0Wpto0oGSLCwuTPgjzquVphCrK8LyRU4T2GPndZkO/T+MkuTw4kdazSploA0bRlwhxiqeEsxuCLZkdbvLX5z77XvwJS0FDCbBV4HH3KWLfEA+Xchq9jW7H+H6qK2UCOJJhKemDRLVZPXIppDIl3OxZJWXlGMMHgdR1rpmHhPYxz+98lv+n77r6QBG5qM0S+l7VJn7MH6V4OhGwR+4M7WLFaD7YLI0oH9Df5IUI/x6JEybRGAZBdlFCEVSbyHlknJI1dmTwpC46H4pQh1CQBSI8F9A9JFrhMFzkz6yVkl11ZzXSLd6Gh44kpJJT9vD8UiKOM4pweiRbW1pERdJLEUTq9RsUB5JiEP/+7nBQOphcVgchF2aG6+nwsD4qMZ5zPYzlLFcP/idIyzTkqzT2xTz4ejTVAze5pDVHRqA6lzCnpDhFdjOw== vickatte@LAPTOP-U8JKHFG0"
}

resource "aws_security_group" "lb_sg" {
  name        = "alb_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${data.terraform_remote_state.remote.outputs.vpc_id}"

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


####################################################################################################


resource "aws_lb" "web-ext" {
  name               = "web-tier-lb-ext"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["${data.terraform_remote_state.remote.outputs.public_subnets[0]}", "${data.terraform_remote_state.remote.outputs.public_subnets[1]}"]

  enable_deletion_protection = false


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-ext.arn
  port              = "80"
  protocol          = "HTTP"
  ##ssl_policy        = "ELBSecurityPolicy-2016-08"
  ##certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.remote.outputs.vpc_id}"

  health_check {
    enabled           = true
    healthy_threshold = 3
    interval          = 10
    path              = "/wp-admin/install.php"
    port              = "80"
  }
}


resource "aws_lb_target_group_attachment" "bar" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.bar.id
  port             = 80
}


##resource "aws_lb_listener_certificate" "example" {
##  listener_arn    = aws_lb_listener.front_end.arn
##  certificate_arn = aws_acm_certificate.example.arn
##}
##
##


resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }

  condition {
    host_header {
      values = ["example.com"]
    }
  }
}
