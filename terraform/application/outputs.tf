################################################################################
# Security group
################################################################################
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.asg_sg.security_group_id
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.asg_sg.security_group_vpc_id
}

output "security_group_owner_id" {
  description = "The owner ID"
  value       = module.asg_sg.security_group_owner_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.asg_sg.security_group_name
}

output "security_group_description" {
  description = "The description of the security group"
  value       = module.asg_sg.security_group_description
}

################################################################################
# Autoscaling group
################################################################################

output "asg_launch_template_id" {
  description = "The ID of the launch template"
  value       = module.asg.launch_template_id
}

output "asg_launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.asg.launch_template_arn
}

output "asg_launch_template_name" {
  description = "The name of the launch template"
  value       = module.asg.launch_template_name
}

output "asg_launch_template_latest_version" {
  description = "The latest version of the launch template"
  value       = module.asg.launch_template_latest_version
}

output "asg_launch_template_default_version" {
  description = "The default version of the launch template"
  value       = module.asg.launch_template_default_version
}

output "asg_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.asg.autoscaling_group_id
}

output "asg_autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = module.asg.autoscaling_group_name
}

output "asg_autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = module.asg.autoscaling_group_arn
}

output "asg_autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = module.asg.autoscaling_group_min_size
}

output "asg_autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = module.asg.autoscaling_group_max_size
}

output "asg_autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = module.asg.autoscaling_group_desired_capacity
}

output "asg_autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = module.asg.autoscaling_group_default_cooldown
}

output "asg_autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = module.asg.autoscaling_group_health_check_grace_period
}

output "asg_autoscaling_group_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = module.asg.autoscaling_group_health_check_type
}

output "asg_autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = module.asg.autoscaling_group_availability_zones
}

output "asg_autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = module.asg.autoscaling_group_vpc_zone_identifier
}

output "asg_autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = module.asg.autoscaling_group_load_balancers
}

output "asg_autoscaling_group_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = module.asg.autoscaling_group_target_group_arns
}

output "asg_autoscaling_schedule_arns" {
  description = "ARNs of autoscaling group schedules"
  value       = module.asg.autoscaling_schedule_arns
}

output "asg_autoscaling_policy_arns" {
  description = "ARNs of autoscaling policies"
  value       = module.asg.autoscaling_policy_arns
}

output "asg_autoscaling_group_enabled_metrics" {
  description = "List of metrics enabled for collection"
  value       = module.asg.autoscaling_group_enabled_metrics
}

output "asg_iam_role_name" {
  description = "The name of the IAM role"
  value       = module.asg.iam_role_name
}

output "asg_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.asg.iam_role_arn
}

output "asg_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.asg.iam_role_unique_id
}

output "asg_iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.asg.iam_instance_profile_arn
}

output "asg_iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.asg.iam_instance_profile_id
}

output "asg_iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = module.asg.iam_instance_profile_unique
}

################################################################################
# Launch template only
################################################################################

output "launch_template_only_launch_template_id" {
  description = "The ID of the launch template"
  value       = module.asg.launch_template_id
}

output "launch_template_only_launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.asg.launch_template_arn
}

output "launch_template_only_launch_template_name" {
  description = "The name of the launch template"
  value       = module.asg.launch_template_name
}

output "launch_template_only_launch_template_latest_version" {
  description = "The latest version of the launch template"
  value       = module.asg.launch_template_latest_version
}

output "launch_template_only_launch_template_default_version" {
  description = "The default version of the launch template"
  value       = module.asg.launch_template_default_version
}

################################################################################
# Application load balancer (ALB) outputs
################################################################################

output "alb_security_group_id" {
  description = "The ID of the security group"
  value       = module.alb_http_sg.security_group_id
}

output "alb_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.alb_http_sg.security_group_vpc_id
}

output "alb_security_group_owner_id" {
  description = "The owner ID"
  value       = module.alb_http_sg.security_group_owner_id
}

output "alb_security_group_name" {
  description = "The name of the security group"
  value       = module.alb_http_sg.security_group_name
}

output "alb_security_group_description" {
  description = "The description of the security group"
  value       = module.alb_http_sg.security_group_description
}
output "lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.lb_id
}

output "lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.lb_arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.alb.lb_arn_suffix
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.alb.lb_zone_id
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_ids
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.alb.https_listener_arns
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = module.alb.https_listener_ids
}


################################################################################
# Elastic File System
################################################################################

output "efs_arn" {
  description = "Amazon Resource Name of the file system"
  value       = module.efs.arn
}

output "efs_id" {
  description = "The ID that identifies the file system (e.g., `fs-ccfc0d65`)"
  value       = module.efs.id
}

output "efs_dns_name" {
  description = "The DNS name for the filesystem per [documented convention](http://docs.aws.amazon.com/efs/latest/ug/mounting-fs-mount-cmd-dns-name.html)"
  value       = module.efs.dns_name
}

output "efs_size_in_bytes" {
  description = "The latest known metered size (in bytes) of data stored in the file system, the value is not the exact size that the file system was at any point in time"
  value       = module.efs.size_in_bytes
}

output "efs_mount_targets" {
  description = "Map of mount targets created and their attributes"
  value       = module.efs.mount_targets
}

output "efs_access_points" {
  description = "Map of access points created and their attributes"
  value       = module.efs.access_points
}


################################################################################
# Relational database service (RDS) outputs
################################################################################
##output "db_instance_address" {
##  description = "The address of the RDS instance"
##  value       = module.rds.db_instance_address
##}
##output "db_instance_arn" {
##  description = "The ARN of the RDS instance"
##  value       = module.rds.db_instance_arn
##}
##output "db_instance_availability_zone" {
##  description = "The availability zone of the RDS instance"
##  value       = module.rds.db_instance_availability_zone
##}
##output "db_instance_endpoint" {
##  description = "The connection endpoint"
##  value       = module.rds.db_instance_endpoint
##}
##output "db_instance_engine" {
##  description = "The database engine"
##  value       = module.rds.db_instance_engine
##}
##output "db_instance_engine_version_actual" {
##  description = "The running version of the database"
##  value       = module.rds.db_instance_engine_version_actual
##}
##output "db_instance_hosted_zone_id" {
##  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
##  value       = module.rds.db_instance_hosted_zone_id
##}
##output "db_instance_id" {
##  description = "The RDS instance ID"
##  value       = module.rds.db_instance_id
##}
##output "db_instance_resource_id" {
##  description = "The RDS Resource ID of this instance"
##  value       = module.rds.db_instance_resource_id
##}
##output "db_instance_status" {
##  description = "The RDS instance status"
##  value       = module.rds.db_instance_status
##}
##output "db_instance_name" {
##  description = "The database name"
##  value       = module.rds.db_instance_name
##}
##output "db_instance_username" {
##  description = "The master username for the database"
##  value       = module.rds.db_instance_username
##  sensitive   = true
##}
##output "db_instance_password" {
##  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
##  value       = module.rds.db_instance_password
##  sensitive   = true
##}
##output "db_instance_port" {
##  description = "The database port"
##  value       = module.rds.db_instance_port
##}
##output "db_subnet_group_id" {
##  description = "The db subnet group name"
##  value       = module.rds.db_subnet_group_id
##}
##output "db_subnet_group_arn" {
##  description = "The ARN of the db subnet group"
##  value       = module.rds.db_subnet_group_arn
##}
##output "db_parameter_group_id" {
##  description = "The db parameter group id"
##  value       = module.rds.db_parameter_group_id
##}
##output "db_parameter_group_arn" {
##  description = "The ARN of the db parameter group"
##  value       = module.rds.db_parameter_group_arn
##}
##output "db_instance_domain" {
##  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
##  value       = module.rds.db_instance_domain
##}
##output "db_instance_domain_iam_role_name" {
##  description = "The name of the IAM role to be used when making API calls to the Directory Service. "
##  value       = module.rds.db_instance_domain_iam_role_name
##}
##output "db_enhanced_monitoring_iam_role_arn" {
##  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
##  value       = module.rds.enhanced_monitoring_iam_role_arn
##}
##output "db_instance_cloudwatch_log_groups" {
##  description = "Map of CloudWatch log groups created and their attributes"
##  value       = module.rds.db_instance_cloudwatch_log_groups
##}
##
