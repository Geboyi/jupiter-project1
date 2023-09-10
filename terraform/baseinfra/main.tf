module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jupiter-3tier-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.10.10.0/24", "10.10.20.0/24", "10.10.30.0/24", "10.10.40.0/24"]
  public_subnets  = ["10.10.110.0/24", "10.10.120.0/24"]

  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
