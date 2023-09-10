output "vpc_id" {
  description = "vpc ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.private_subnets
}
