################################################################################
# External Supporting Resources
################################################################################

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.0"

  name        = var.alb_sg_name
  vpc_id      = data.terraform_remote_state.remote.outputs.vpc_id
  description = var.alb_sg_description

  ingress_cidr_blocks = var.alb_sg_ingress_cidr_blocks
  tags                = var.alb_sg_tags
}

################################################################################
# Application load balancer (ALB)
################################################################################

module "alb" {
  source          = "terraform-aws-modules/alb/aws"
  version         = "~> 6.0"
  name            = var.alb_name
  vpc_id          = data.terraform_remote_state.remote.outputs.vpc_id
  subnets         = data.terraform_remote_state.remote.outputs.public_subnets
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
      name             = var.alb_target_group_name
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

  tags = var.alb_tags
}

## create a public zone
##resource "aws_route53_zone" "alb_zone" {
##  name = "gerald.com"
##
##}
##
#### make entries into the zone
##resource "aws_route53_record" "alb_dns" {
##  zone_id = aws_route53_zone.alb_zone.zone_id
##  name    = "mango.gerald.com" ## nickname
##  type    = "CNAME"
##  ttl     = "30"
##  records = [module.alb.lb_dns_name] ## realname
##}
