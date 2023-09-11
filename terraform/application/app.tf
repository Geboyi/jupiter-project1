################################################################################
# Supporting Resources
################################################################################

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.0"

  name        = var.alb_sg_app-tier-name
  vpc_id      = module.vpc.vpc_id
  description = var.alb_sg_app-tier-description

  ingress_cidr_blocks = var.alb_sg_app-tier-ingress_cidr_blocks
  tags                = var.alb_sg_app-tier-tags
}

################################################################################
# Application load balancer (ALB)
################################################################################

module "alb" {
  source          = "terraform-aws-modules/alb/aws"
  version         = "~> 6.0"
  name            = var.alb_app-tier-name
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_http_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = var.alb_app-tier-target_group_name
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness       = { "enabled" = true, "type" = "lb_cookie" }
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/wp-admin/install.php"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
  ]

  tags = var.alb_app-tier-tags
}



########### ASG
################################################################################
# Local variables
################################################################################

locals {
##  user_data = <<-EOT
###!/bin/bash
##yum update -y
##amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
##yum install -y httpd
##systemctl start httpd
##systemctl enable httpd
##usermod -a -G apache ec2-user
##chown -R ec2-user:apache /var/www
##chmod 2775 /var/www
##find /var/www -type d -exec chmod 2775 {} \;
##find /var/www -type f -exec chmod 0664 {} \;
##echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
##sudo yum install php-mbstring php-xml -y
##sudo systemctl restart httpd
##sudo systemctl restart php-fpm
##cd /var/www/html
##wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
##mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
##rm phpMyAdmin-latest-all-languages.tar.gz
##echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
##cd phpMyAdmin
##mv config.sample.inc.php config.inc.php
##sed -i 's/localhost/${module.rds.db_instance_address}/g' config.inc.php
##  EOT

user_data_wp = <<EOF
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

}

################################################################################
# Supporting Resources
################################################################################

module "asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.asg_sg_app-tier-name
  description = var.asg_sg_app-tier-description
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_http_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = var.asg_sg_app-tier-tags
}

################################################################################
# Autoscaling scaling group (ASG)
################################################################################

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.asg_app-tier-name

  min_size                  = var.asg_app-tier-min_size
  max_size                  = var.asg_app-tier-max_size
  desired_capacity          = var.asg_app-tier-desired_capacity
  wait_for_capacity_timeout = var.asg_app-tier-wait_for_capacity_timeout
  health_check_type         = var.asg_app-tier-health_check_type
  vpc_zone_identifier       = module.vpc.private_subnets
  target_group_arns         = module.alb.target_group_arns
  user_data                 = base64encode(local.user_data_wp)

  # Launch template
  launch_template_name        = var.asg_app-tier-launch_template_name
  launch_template_description = var.asg_app-tier-launch_template_description
  update_default_version      = var.asg_app-tier-update_default_version

  image_id          = var.asg_app-tier-image_id
  instance_type     = var.asg_app-tier-instance_type
  ebs_optimized     = var.asg_app-tier-ebs_optimized
  enable_monitoring = var.asg_app-tier-enable_monitoring

  # IAM role & instance profile
  create_iam_instance_profile = var.asg_app-tier-create_iam_instance_profile
  iam_role_name               = var.asg_app-tier-iam_role_name
  iam_role_path               = var.asg_app-tier-iam_role_path
  iam_role_description        = var.asg_app-tier-iam_role_description
  iam_role_tags               = var.asg_app-tier-iam_role_tags
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.asg_app-tier-block_device_mappings_volume_size_0
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.asg_app-tier-block_device_mappings_volume_size_1
        volume_type           = "gp2"
      }
    }
  ]

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.asg_sg.security_group_id]
    },
    {
      delete_on_termination = true
      description           = "eth1"
      device_index          = 1
      security_groups       = [module.asg_sg.security_group_id]
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = var.asg_app-tier-instance_tags
    },
    {
      resource_type = "volume"
      tags          = var.asg_app-tier-volume_tags
    }
  ]

  tags = var.asg_app-tier-tags
}
