pip install awscli
aws configure
mkdir terraform-variables-aws-using-cli && cd $_
code main.tf
# provider "aws" {
#   region = "eu-west-2"
# }

# resource "aws_instance" "example" {
#   ami           = var.ami
#   instance_type = var.type
# }

code variables.tf
# variable "ami" {
#   description = "machine image"
# }

# variable "type" {
#   description = "machine size"
# }

terraform init
terraform plan
# ami-0015a39e4b7c0966f
# t2.micro

terraform apply
# ami-0015a39e4b7c0966f
# t2.micro

terraform destroy
