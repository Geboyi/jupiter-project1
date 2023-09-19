
# RDS variables
variable "rds_sg_name" {
  description = "Relational database service security group name"
  type        = string
  default     = "demo-rds-sg"
}

variable "rds_sg_description" {
  description = "Relational database service security group description"
  type        = string
  default     = "demo-rds-sg"
}

variable "rds_sg_tags" {
  description = "Relational database service security group tags"
  type        = map(string)
  default     = { "Name" = "demo-rds-sg", "created-by" = "terraform" }
}

variable "rds_identifier" {
  description = "Relational database service identifier"
  type        = string
  default     = "demo-rds"
}

variable "rds_mysql_engine" {
  description = "Relational database service mysql engine"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "Relational database service mysql engine version"
  type        = string
  default     = "8.0.27"
}

variable "rds_family" {
  description = "Relational database service family"
  type        = string
  default     = "mysql8.0"
}

variable "rds_major_engine_version" {
  description = "Relational database service major engine version"
  type        = string
  default     = "8.0"
}

variable "rds_instance_class" {
  description = "Relational database service instance class"
  type        = string
  default     = "db.t2.small"
}

variable "rds_allocated_storage" {
  description = "Relational database service allocated storage"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Relational database service max allocated storage"
  type        = number
  default     = 100
}

variable "rds_db_name" {
  description = "Relational database service db name"
  type        = string
  default     = "demo_mysql"
}

variable "rds_username" {
  description = "Relational database service username"
  type        = string
  default     = "demo_user"
}

variable "rds_port" {
  description = "Relational database service port"
  type        = number
  default     = 3306
}

variable "rds_multi_az" {
  description = "Relational database service multi az"
  type        = bool
  default     = false
}

variable "rds_maintenance_window" {
  description = "Relational database service maintenance window"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "rds_backup_window" {
  description = "Relational database service backup window"
  type        = string
  default     = "03:00-06:00"
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = "Relational database service enabled cloudwatch log exports"
  type        = list(any)
  default     = ["general"]
}

variable "rds_create_cloudwatch_log_group" {
  description = "Relational database service create cloudwatch log group"
  type        = bool
  default     = true
}

variable "rds_backup_retention_period" {
  description = "Relational database service backup retention period"
  type        = number
  default     = 0
}

variable "rds_skip_final_snapshot" {
  description = "Relational database service skip final snapshot"
  type        = bool
  default     = true
}

variable "rds_deletion_protection" {
  description = "Relational database service deletion protection"
  type        = bool
  default     = false
}

variable "rds_performance_insights_enabled" {
  description = "Relational database service insights enabled"
  type        = bool
  default     = false
}

variable "rds_performance_insights_retention_period" {
  description = "Relational database service retention period"
  type        = number
  default     = 7
}

variable "rds_create_monitoring_role" {
  description = "Relational database service create monitoring role"
  type        = bool
  default     = true
}

variable "rds_monitoring_interval" {
  description = "Relational database service monitoring interval"
  type        = number
  default     = 60
}

variable "rds_tags" {
  description = "Relational database service tags"
  type        = map(string)
  default     = { "Name" = "demo-rds", "created-by" = "terraform" }
}

variable "rds_db_instance_tags" {
  description = "Relational database service db instance tags"
  type        = map(string)
  default     = { "Name" = "demo-rds", "created-by" = "terraform" }
}

variable "rds_db_option_group_tags" {
  description = "Relational database service db option group tags"
  type        = map(string)
  default     = { "Name" = "demo-rds", "created-by" = "terraform" }
}

variable "rds_db_parameter_group_tags" {
  description = "Relational database service db parameter group tags"
  type        = map(string)
  default     = { "Name" = "demo-rds", "created-by" = "terraform" }
}

variable "rds_db_subnet_group_tags" {
  description = "Relational database service db subnet group tags"
  type        = map(string)
  default     = { "Name" = "demo-rds", "created-by" = "terraform" }
}
