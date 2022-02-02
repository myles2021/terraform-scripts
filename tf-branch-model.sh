# using the branch model to deploy two ec2 instances in two different regions

mkdir tf-branch-model-2 && cd $_ && mkdir environments modules && cd environments && mkdir production staging && touch production/production.tf production/production.tfvars staging/staging.tf staging/staging.tfvars && cd ../modules && mkdir infrastructure && cd infrastructure && touch main.tf output.tf variables.tf
mkdir ec2 && cd $_ && touch main.tf output.tf variables.tf
cd .. && mkdir vpc && cd $_ && touch main.tf output.tf variables.tf
cd .. && mkdir subnets && cd $_ && touch main.tf output.tf variables.tf
cd .. && code main.tf 
# module "vpc" {
#   source      = "./vpc"

#   environment = var.environment
#   region      = var.region
# }
# module "ec2" {
#   source      = "./ec2"

#   environment       = var.environment
#   region            = var.region
#   ami_id            = var.ami_id
#   public_subnet_id  = module.subnets.public_subnet_id
#   private_subnet_id = module.subnets.private_subnet_id
# }
# module "subnets" {
#   source      = "./subnets"

#   environment = var.environment
#   region      = var.region
#   vpc_id      = module.vpc.vpc_id
# }

code variables.tf
# variable "environment" {
# }
# variable "region" {
# }
# variable "ami_id" {
# }

code vpc/main.tf
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "${var.region}-${var.environment}-vpc"
#   }
# }

code subnets/main.tf
# resource "aws_subnet" "public_subnet" {
#   vpc_id     =  "${var.vpc_id}"
#   cidr_block = "10.0.0.0/24"

#   tags = {
#     Name = "${var.environment}-${var.region}-Public-Subnet"
#   }
# }
# resource "aws_subnet" "private_subnet" {
#   vpc_id     =  "${var.vpc_id}"
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "${var.environment}-${var.region}-Private-Subnet"
#   }
# }

code ec2/main.tf
# resource "aws_instance" "public_instance" {
#    ami                         = "${var.ami_id}"
#    instance_type               = "t2.micro"
#    subnet_id                   = "${var.public_subnet_id}"
#    associate_public_ip_address = true

#  tags = {
#     Name = "${var.environment}-${var.region}-Public"
#   }
# }
# resource "aws_instance" "private_instance" {
#    ami                         = "${var.ami_id}"
#    instance_type               = "t2.micro"
#    subnet_id                   = "${var.private_subnet_id}"
#    associate_public_ip_address = false

#  tags = {
#     Name = "${var.environment}-${var.region}-Private"
#   }
# }

cd ../../environments
code production/production.tf
# variable "environment" {
# }
# variable "region" {
# }
# variable "access_key" {
# }
# variable "secret_key" {
# }
# variable "ami_id" {
# }

# provider "aws" {
#    region = var.region
#    version = "~> 2.7"
#    access_key = var.access_key
#    secret_key = var.secret_key
# }

# module "infrastructure" {
#    source      = "../../modules/infrastructure"
#    environment = var.environment
#    region      = var.region
#    ami_id      = var.ami_id
# }

code production/production.tfvars
# # Operates in London
# environment  = "production"
# region       = "eu-west-2"
# access_key   = "input access key"
# secret_key   = "input secret key"
# ami_id       = "ami-0015a39e4b7c0966f"

code staging/staging.tf
# variable "environment" {
# }
# variable "region" {
# }
# variable "access_key" {
# }
# variable "secret_key" {
# }
# variable "ami_id" {
# }

# provider "aws" {
#    region = var.region
#    version = "~> 2.7"
#    access_key = var.access_key
#    secret_key = var.secret_key
# }

# module "infrastructure" {
#    source      = "../../modules/infrastructure"
#    environment = var.environment
#    region      = var.region
#    ami_id      = var.ami_id
# }

code staging/staging.tfvars
# # Operates in Ireland
# environment  = "staging"
# region       = "eu-west-1"
# access_key   = "input access key"
# secret_key   = "input secret key"
# ami_id       = "ami-0713f98de93617bb4"

cd staging
terraform init
terraform plan --var-file=staging.tfvars -out=stagingplan
terraform apply "stagingplan"
terraform destroy --var-file=staging.tfvars


