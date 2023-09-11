####### ALB variables
variable "alb_sg_app-tier-name" {
  description = "Application load balancer security group name for app tier"
  type        = string
  default     = "demo-alb-sg"
}

variable "alb_sg_app-tier-ingress_cidr_blocks" {
  description = "Application load balancer cidr blocks"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "alb_sg_app-tier-description" {
  description = "Application load balancer security group description for app tier"
  type        = string
  default     = "demo-alb-sg"
}

variable "alb_sg_app-tier-tags" {
  description = "Application load balancer security group tags for app tier"
  type        = map(string)
  default     = { "Name" = "demo-alb-sg", "created-by" = "terraform" }
}

variable "alb_app-tier-description" {
  description = "Application load balancer description for app tier"
  type        = string
  default     = "demo-alb"
}

variable "alb_app-tier-name" {
  description = "Application load balancer name for app tier"
  type        = string
  default     = "demo-alb"
}

variable "alb_app-tier-http_tcp_listeners_port" {
  description = "Application load balancer http listeners port for app tier"
  type        = number
  default     = 80
}

variable "alb_app-tier-target_group_name" {
  description = "Application load balancer target group name for app tier"
  type        = string
  default     = "demo-alb-tg"
}

variable "alb_app-tier-target_groups_backend_port" {
  description = "Application load balancer http listeners port for app tier"
  type        = number
  default     = 80
}

variable "alb_app-tier-tags" {
  description = "Application load balancer tags"
  type        = map(string)
  default     = { "Name" = "demo-alb", "created-by" = "terraform" }
}



######## ASG variables
variable "asg_sg_app-tier-name" {
  description = "Name of the autoscaling group security group for app tier"
  type        = string
  default     = "demo-asg-sg"
}

variable "asg_sg_app-tier-description" {
  description = "Description of the autoscaling group security group for app tier"
  type        = string
  default     = "demo-asg-sg"
}

variable "asg_sg_app-tier-tags" {
  description = "Tags for autoscaling group security group app tier"
  type        = map(string)
  default     = { "Name" = "demo-asg-sg", "created-by" = "terraform" }
}

variable "asg_app-tier-name" {
  description = "Name of the autoscaling group for app tier"
  type        = string
  default     = "demo-asg"
}

variable "asg_app-tier-min_size" {
  description = "Auto scaling minimum size for app tier"
  type        = number
  default     = 2
}

variable "asg_app-tier-max_size" {
  description = "Auto scaling maximum size for app tier"
  type        = number
  default     = 2
}

variable "asg_app-tier-desired_capacity" {
  description = "Auto scaling desired capacity for app tier"
  type        = number
  default     = 2
}

variable "asg_app-tier-wait_for_capacity_timeout" {
  description = "Auto scaling wait for capacity timeout for app tier"
  type        = number
  default     = 0
}

variable "asg_app-tier-health_check_type" {
  description = "Auto scaling health check type for app tier"
  type        = string
  default     = "EC2"
}

variable "asg_app-tier-launch_template_name" {
  description = "Name of the autoscaling group launch template app tier"
  type        = string
  default     = "demo-lt"
}

variable "asg_app-tier-launch_template_description" {
  description = "Description of the autoscaling group security group app tier"
  type        = string
  default     = "demo-lt"
}

variable "asg_app-tier-update_default_version" {
  description = "Auto scaling group update default version app tier"
  type        = bool
  default     = true
}

variable "asg_app-tier-image_id" {
  description = "Auto scaling group image id app tier"
  type        = string
  default     = "ami-026b57f3c383c2eec"
}

variable "asg_app-tier-instance_type" {
  description = "Auto scaling group instance type app tier"
  type        = string
  default     = "t3.micro"
}

variable "asg_app-tier-ebs_optimized" {
  description = "Auto scaling group ebs optimized app tier"
  type        = bool
  default     = true
}

variable "asg_app-tier-enable_monitoring" {
  description = "Auto scaling group enable monitoring app tier"
  type        = bool
  default     = true
}

variable "asg_app-tier-create_iam_instance_profile" {
  description = "Auto scaling group create iam instance profile app tier"
  type        = bool
  default     = true
}

variable "asg_app-tier-iam_role_name" {
  description = "Auto scaling group iam role name app tier"
  type        = string
  default     = "demo-asg-iam-role"
}

variable "asg_app-tier-iam_role_path" {
  description = "Auto scaling group iam role path app tier"
  type        = string
  default     = "/ec2/"
}

variable "asg_app-tier-iam_role_description" {
  description = "Auto scaling group iam role description app tier"
  type        = string
  default     = "demo-asg-iam-role"
}

variable "asg_app-tier-iam_role_tags" {
  description = "Auto scaling group iam role tags app tier"
  type        = map(string)
  default     = { "Name" = "demo-asg-iam-role", "created-by" = "terraform" }
}

variable "asg_app-tier-block_device_mappings_volume_size_0" {
  description = "Auto scaling group block device mapping volume size 0 app tier"
  type        = number
  default     = 20
}

variable "asg_app-tier-block_device_mappings_volume_size_1" {
  description = "Auto scaling group block device mapping volume size 1 app tier"
  type        = number
  default     = 30
}

variable "asg_app-tier-instance_tags" {
  description = "Auto scaling group instance tags app tier"
  type        = map(string)
  default     = { "Name" = "demo-asg-instance", "created-by" = "terraform" }
}

variable "asg_app-tier-volume_tags" {
  description = "Auto scaling group volume tags app tier"
  type        = map(string)
  default     = { "Name" = "demo-asg-volume", "created-by" = "terraform" }
}

variable "asg_app-tier-tags" {
  description = "Auto scaling group tags app tier"
  type        = map(string)
  default     = { "Name" = "demo-asg", "created-by" = "terraform" }
}
