pip install awscli
aws configure
mkdir terraform-variables && cd $_
touch main.tf variables.tf variableValues.tfvars
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

code variableValues.tfvars 
# ami  = "ami-0015a39e4b7c0966f"
# type = "t2.micro"

terraform fmt
terraform init
terraform plan -var-file="variableValues.tfvars"
terraform apply -var-file="variableValues.tfvars"
terraform destroy -var-file="variableValues.tfvars"
