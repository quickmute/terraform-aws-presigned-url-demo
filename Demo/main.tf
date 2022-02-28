##Provide these via tfvars files
variable "myip"{}
variable "bucketname"{}
variable "access_key"{}
variable "secret_key"{}

module "demo" {
  source     = "../."
  myip       = var.myip
  bucketname = var.bucketname
}

provider "aws" {
  region     = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

output "website"{
    value = module.demo.website
}
