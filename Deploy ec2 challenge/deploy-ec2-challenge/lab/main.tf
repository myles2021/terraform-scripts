terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7"
    }
  }
  backend "s3" {
    bucket = "RENAMEME!"
    key    = "calabs/production/us-west-2/rslab/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
provider "aws" {
  region = "us-west-2"
}
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "cloudacademylabs"
  }
}
module "webserver" {
    source = "./modules/ec2"
    ami = "ami-0528a5175983e7f28"
    servername = "cloudacademylabs"
    instance_size = "t2.micro"
}
