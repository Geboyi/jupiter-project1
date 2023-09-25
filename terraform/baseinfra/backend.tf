terraform {
  backend "s3" {
    bucket  = "technologiesoutcomes-7878-terraform-backend"
    encrypt = true
    key     = "3tiers/baseinfra/baseinfra-terraform.tfstate"
    region  = "eu-west-1"
    #dynamodb_table = "technologiesoutcomes-3tier-terraform-backend"
  }
}
