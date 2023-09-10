terraform {
  backend "s3" {
    bucket  = "technologiesoutcomes-terraform-backend"
    encrypt = true
    key     = "jupiter/3tier-baseinfra.tfstate"
    region  = "eu-west-1"
    #dynamodb_table = "technologiesoutcomes-terraform-backend"
  }
}
