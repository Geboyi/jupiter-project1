


module "int_alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.0"

  name        = "int_alb_sg_name"
  vpc_id      = "${data.terraform_remote_state.remote.outputs.vpc_id}"
  description = "int_alb_sg_description"

  ingress_cidr_blocks = ["0.0.0.0/0"] #var.alb_sg_ingress_cidr_blocks
  tags                = { "Name" = "demo-alb-sg", "created-by" = "terraform" } ## var.alb_sg_tags
}

################################################################################
# Application load balancer (ALB)
################################################################################

module "int_alb" {
  source          = "terraform-aws-modules/alb/aws"
  version         = "~> 6.0"
  name            = "internalalbname" # var.alb_name
  vpc_id          = "${data.terraform_remote_state.remote.outputs.vpc_id}"
  subnets         = ["${data.terraform_remote_state.remote.outputs.private_subnets[0]}", "${data.terraform_remote_state.remote.outputs.private_subnets[1]}"]
  security_groups = [module.int_alb_http_sg.security_group_id]
  internal = true

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = "intalb-tg" #var.alb_target_group_name
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

  tags = { "Name" = "demo-alb", "created-by" = "terraform" } ##var.alb_tags
}

###############################################################################################################
###  ASG
###############################################################################################################


module "int_asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "intasgname" #var.asg_sg_name
  description = "descr" #var.asg_sg_description
  vpc_id      = "${data.terraform_remote_state.remote.outputs.vpc_id}"

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_http_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = { "Name" = "demo-asg-sg", "created-by" = "terraform" } ##var.asg_sg_tags
}

################################################################################
# Autoscaling scaling group (ASG)
################################################################################

module "int_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "asg" ##var.asg_name

  min_size                  = 2 # var.asg_min_size
  max_size                  = 2 # var.asg_max_size
  desired_capacity          = 2 # var.asg_desired_capacity
  wait_for_capacity_timeout = 0 # var.asg_wait_for_capacity_timeout
  health_check_type         = "EC2" # var.asg_health_check_type
  vpc_zone_identifier       = "${data.terraform_remote_state.remote.outputs.private_subnets}"
  target_group_arns         = module.int_alb.target_group_arns
  user_data                 = base64encode(local.user_data_wp)

  # Launch template
  launch_template_name        = "ltm" ##var.asg_launch_template_name
  launch_template_description = "ltmd" ##var.asg_launch_template_description
  update_default_version      = true ##var.asg_update_default_version

  image_id          = "ami-05432c5a0f7b1bfd0" ##var.asg_image_id
  instance_type     = "t3.micro" ##var.asg_instance_type
  ebs_optimized     = true ##var.asg_ebs_optimized
  enable_monitoring = true ##var.asg_enable_monitoring

  # IAM role & instance profile
  create_iam_instance_profile = true ## var.asg_create_iam_instance_profile
  iam_role_name               = "demo-asg-iam-role" ##var.asg_iam_role_name
  iam_role_path               = "/ec2/" ## var.asg_iam_role_path
  iam_role_description        = "demo-asg-iam-role" ## var.asg_iam_role_description
  iam_role_tags               = { "Name" = "demo-asg-iam-role", "created-by" = "terraform" } ##var.asg_iam_role_tags
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
        volume_size           = 20 ##var.asg_block_device_mappings_volume_size_0
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30 ##var.asg_block_device_mappings_volume_size_1
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
      tags          = { "Name" = "demo-asg-instance", "created-by" = "terraform" } ## var.asg_instance_tags
    },
    {
      resource_type = "volume"
      tags          = { "Name" = "demo-asg-volume", "created-by" = "terraform" } ##var.asg_volume_tags
    }
  ]

  tags = { "Name" = "demo-asg", "created-by" = "terraform" } ##var.asg_tags
}
