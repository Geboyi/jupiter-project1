################################################################################
# Virtual private cloud (VPC)
################################################################################

module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  version                      = "5.1.2"
  name                         = var.vpc_name
  cidr                         = var.vpc_cidr
  azs                          = var.vpc_azs
  private_subnets              = var.vpc_private_subnets
  public_subnets               = var.vpc_public_subnets
  database_subnets             = var.vpc_database_subnets
  create_database_subnet_group = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  enable_nat_gateway           = false
  single_nat_gateway           = false
  tags                         = var.vpc_tags
}
